class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[spotify]
  
  
  has_many :master_playlists
  has_many :minion_playlists

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.save!
    end
  end

  def update_user_playlists
    user_playlists = RSpotify::User.find(self.name).playlists
    user_playlists.each do |user_playlist|
      self.minion_playlists.where(spotify_id: user_playlist.id).first_or_create do |new_playlist|
        new_playlist.name = user_playlist.name
        new_playlist.spotify_id = user_playlist.id
        new_playlist.save!
      end
    end
  end
end
