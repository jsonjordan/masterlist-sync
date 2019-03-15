class MasterPlaylist < ApplicationRecord

    validates :name, presence: true
    validates :spotify_id, presence: true

    belongs_to :user
    has_many :minion_playlists
    
    def initialize_master(minion)
        spotify_master = RSpotify::Playlist.find(self.user.name, self.spotify_id)
        spotify_minion = RSpotify::Playlist.find(self.user.name, minion.spotify_id)
        self.add_tracks(spotify_minion, spotify_master, 0)
        binding.pry
    end

    def add_tracks(spotify_minion, spotify_master, offset)
        binding.pry
        spotify_master.add_tracks!(spotify_minion.tracks(offset: offset))
        if spotify_minion.total - offset > 0
            self.add_tracks(spotify_minion, spotify_master, offset + 100)
        end
    end
end
