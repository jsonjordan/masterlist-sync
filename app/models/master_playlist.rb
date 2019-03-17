class MasterPlaylist < ApplicationRecord

    validates :name, presence: true
    validates :spotify_id, presence: true

    belongs_to :user
    has_many :minion_playlists
    
    def initialize_master
        all_tracks = get_all_tracks(spotify_minion)
        add_tracks_to_master(all_tracks)
        self
    end

    def add_tracks_to_master(tracks, offset = 0)
        if tracks.count > offset
            track_set = tracks[offset..offset + 99]
            spotify_master.add_tracks!(track_set)
            add_tracks_to_master(tracks, offset + 100)
        end
    end

    def update_tracks
        new_tracks = get_new_tracks
        add_tracks(new_tracks)
    end

    def get_new_tracks
        minion_tracks = get_all_tracks(spotify_minion)
        master_tracks = get_all_tracks(spotify_master).map { |track| track.id}

        new_tracks = minion_tracks.select { |track|
            master_tracks.exclude? track.id
        }

        remove_local(new_tracks)
    end

    def get_all_tracks(playlist, tracks_list = [])
        if tracks_list.count < playlist.total
            tracks_list.push(*playlist.tracks(offset: tracks_list.count))
            get_all_tracks(playlist, tracks_list)
        end
        remove_local(tracks_list)
    end


    def remove_local(track_list)
        filtered = track_list.select { |track| track.uri.exclude? "local"}
    end

    def spotify_master
        @spotify_master ||= RSpotify::Playlist.find(self.user.name, self.spotify_id)
    end

    def spotify_minion
        @spotify_minion ||= RSpotify::Playlist.find(self.user.name, self.minion_playlists.first.spotify_id)
    end
end


# spotify_user = RSpotify::User.new(User.first.spotify_hash)
# master = MasterPlaylist.first
# minion = MinionPlaylist.find(6)
# spotify_master = RSpotify::Playlist.find(me.name, master.spotify_id)
# spotify_minion = RSpotify::Playlist.find(me.name, minion.spotify_id)
# master.add_tracks(spotify_minion, spotify_master, 100)