class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[spotify]
  
  
  has_many :master_playlists
  has_many :minion_playlists

  serialize :spotify_hash, Hash

  def self.from_omniauth(auth)
    unless user = User.find_by(provider: auth.provider, uid: auth.uid)
      user = User.new()
    end
    user.provider = auth.provider
    user.uid = auth.uid
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.name = auth.info.name
    user.image = auth.info.image
    user.spotify_hash = auth
    user.save!
    user
  end

  def update_playlist_list
    all_user_playlists.each do |user_playlist|
      unless self.master_playlists.find_by(spotify_id: user_playlist.id)
        self.minion_playlists.where(spotify_id: user_playlist.id).first_or_create do |new_playlist|
          new_playlist.name = user_playlist.name
          new_playlist.spotify_id = user_playlist.id
          new_playlist.image_url = user_playlist.images.first&.dig("url") || ""
          new_playlist.is_valid = false if user_playlist.images.length == 0
          new_playlist.save!
        end
      end
    end
    if existing_master_playlists.any?
      import_existing_master_playlists
    end
  end

  def get_all_playlists(playlist_list = [])
    partial_list = spotify_user.playlists(limit: 50, offset: playlist_list.count)
    playlist_list.push(*partial_list)
    if partial_list.count == 50
      get_all_playlists(playlist_list)
    end
    playlist_list
  end

  def import_existing_master_playlists
    existing_master_playlists.each do |empl|
      playlist_name = empl.name.remove(' SetlistSync')
      if correct_minion = self.minion_playlists.find_by(name: playlist_name)
        correct_minion.upgrade_to_master(empl)
      end
    end
    validate_and_cleanup
  end

  def validate_and_cleanup
    self.master_playlists.each do |maspl|
      if maspl.minion_playlists.exists? && outdated_playlist = self.minion_playlists.find_by(name: maspl.name)
        outdated_playlist.destroy
      end
    end
  end

  def all_user_playlists
    @all_user_playlists ||= get_all_playlists
  end

  def spotify_user
    @spotify_user ||= RSpotify::User.find(self.name)
  end

  def existing_master_playlists
    @existing_master_playlists ||= self.minion_playlists.where("name LIKE ?", '% SetlistSync%')
  end
end
