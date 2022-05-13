class MasterPlaylist < ApplicationRecord

    validates :name, presence: true
    validates :spotify_id, presence: true

    belongs_to :user
    has_many :minion_playlists
    
    def initialize_master
        add_tracks_to_master(minion_tracks)
        update_img
        self.track_count = minion_tracks.count
        self.last_updated = Date.today
        self.last_checked = Date.today
        set_stats
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
        master_tracks_ids = get_all_tracks(spotify_master).map { |track| track.id}

        new_tracks = minion_tracks.select { |track|
            master_tracks_ids.exclude? track.id
        }
        update_tracks_count
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
        update_last_song_added
        update_tracks_count
        update_most_frequent_artists
        update_alphatunez_achievement
        # TODO other achievements
        # TODO try to use more active record
        self.save
    end

    def remove_local(track_list)
        filtered = track_list.select { |track| track.uri.exclude? "local"}
    end

    def update_img
        old_image = self.image_url
        update_spotify_master
        self.image_url = @spotify_master.images.first&.dig("url") || self.minion_playlists.first.image_url || ""
        self.save if old_image != self.image_url
    end

    def update_tracks_count
        self.track_count = master_tracks.count
    end

    def update_last_song_added
        song = master_tracks.last
        self.last_song_added = "#{song.name} by #{song.artists.first.name}"
    end

    def update_most_frequent_artists
        self.top_artists = get_top_five_artists
    end

    def get_top_five_artists
        top_artists = master_tracks.map { |track| track.artists.first.name }
            .group_by(&:itself)
            .values
            .sort_by(&:length)
            .reverse
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

    def update_alphatunez_achievement
        numbers_and_symbols = ('0'..'9').to_a.push('!','@','$','%','^','&','*','(',')','<','>','?')
        first_letter_track_titles = master_tracks.map { |track| track.name[0].upcase }
            .map { |letter| numbers_and_symbols.include?(letter) ? '#' : letter }
            .group_by(&:itself)
            .values
            .sort
            .flatten
            .uniq

        self.missing_alphatunez_letters = ('A'..'Z').to_a.push('#')
            .select { |letter| first_letter_track_titles.exclude?(letter)}
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

    def minion_tracks
        @minion_tracks ||= get_all_tracks(spotify_minion)
    end

    def master_tracks
        @master_tracks ||= get_all_tracks(spotify_master)
    end
end