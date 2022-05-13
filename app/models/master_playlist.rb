class MasterPlaylist < ApplicationRecord

    validates :name, presence: true
    validates :spotify_id, presence: true

    belongs_to :user
    has_many :minion_playlists
    
    def initialize_master
        all_tracks = get_all_tracks(spotify_minion)
        add_tracks_to_master(all_tracks)
        update_img
        self.track_count = all_tracks.count
        self.last_updated = Date.today
        self.last_checked = Date.today
        update_last_song_added(all_tracks.last)
        self.save
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
        if new_tracks.any?
            add_tracks_to_master(new_tracks)
            update_last_song_added(new_tracks.last)
            self.last_updated = Date.today
        end
        self.last_checked = Date.today
        self.save
    end

    def get_new_tracks
        minion_tracks = get_all_tracks(spotify_minion)
        master_tracks = get_all_tracks(spotify_master).map { |track| track.id}

        new_tracks = minion_tracks.select { |track|
            master_tracks.exclude? track.id
        }
        update_tracks_count(master_tracks)
        remove_local(new_tracks)
    end

    def get_all_tracks(playlist, tracks_list = [])
        if tracks_list.count < playlist.total
            tracks_list.push(*playlist.tracks(offset: tracks_list.count))
            get_all_tracks(playlist, tracks_list)
        end
        remove_local(tracks_list)
    end

    def set_stats
        all_tracks = remove_local(get_all_tracks(spotify_master))
        update_last_song_added(all_tracks.last)
        update_tracks_count(all_tracks)
        update_most_frequent_artists(all_tracks)
        # TODO add most frequent artists
        # TODO do you have the alphatunez?  a-z  other achievements
        # TODO try to use more active record (.pluck instead of map)
        # TODO add rake task to set stats for prod
        self.save
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

    def update_spotify_master
        @spotify_master = RSpotify::Playlist.find(self.user.name, self.spotify_id)
    end


    def update_img
        old_image = self.image_url
        update_spotify_master
        self.image_url = @spotify_master.images.first&.dig("url") || self.minion_playlists.first.image_url || ""
        self.save if old_image != self.image_url
    end

    def update_tracks_count(tracks_list)
        self.track_count = tracks_list.count
    end

    def update_last_song_added(song)
        self.last_song_added = "#{song.name} by #{song.artists.first.name}"
    end

    def update_most_frequent_artists(track_list)
        self.top_artists = get_top_five_artists(track_list)
    end

    def get_top_five_artists(track_list)
        top_artists = track_list.map { |track| track.artists.first.name }
            .group_by(&:itself).values
            .sort_by(&:length).reverse
            .first(5)

        artist_count = []
        top_artists.each do |artist|
            artist_info = {
                'artist_name' => artist.first,
                'songs_count' => artist.count
            }
            artist_count.push(artist_info)
        end
        artist_count
    end
end