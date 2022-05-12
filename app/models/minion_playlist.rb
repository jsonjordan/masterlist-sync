class MinionPlaylist < ApplicationRecord

    validates :name, presence: true
    validates :spotify_id, presence: true

    belongs_to :master_playlist, optional: true
    belongs_to :user
    
    def make_master
        unless self.user.master_playlists.find_by(name: "#{self.name} SetlistSync")
            spotify_user = RSpotify::User.new(self.user.spotify_hash)
            spotify_new_master = spotify_user.create_playlist!("#{self.name} SetlistSync", public: false)
            new_master = self.user.master_playlists.create(
                name: "#{self.name} SetlistSync",
                spotify_id: spotify_new_master.id,
            )
            self.master_playlist = new_master
            self.save

            new_master.initialize_master

        end
    end

    def upgrade_to_master(importing_master)
        unless self.user.master_playlists.find_by(name: "#{self.name} SetlistSync")
            new_master = self.user.master_playlists.create(
                name: importing_master.name,
                spotify_id: importing_master.spotify_id,
                user_id: importing_master.user_id,
                image_url: importing_master.image_url,
                last_checked: Date.today,
                last_updated: Date.today,
            )
            self.master_playlist = new_master
            self.save
        end
    end
end
