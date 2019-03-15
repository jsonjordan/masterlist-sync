class MinionPlaylist < ApplicationRecord

    validates :name, presence: true
    validates :spotify_id, presence: true

    belongs_to :master_playlist, optional: true
    belongs_to :user
    
    def make_master
        binding.pry
        unless self.user.master_playlists.find_by(name: "#{self.name} Master")
            spotify_user = RSpotify::User.new(self.user.spotify_hash)
            spotify_new_master = spotify_user.create_playlist!("#{self.name} Master")
            new_master = self.user.master_playlists.create(
                name: "#{self.name} Master",
                spotify_id: spotify_new_master.id
            )
            self.master_playlist = new_master
            self.save

            new_master.initialize_master(self)

        end
    end
end
