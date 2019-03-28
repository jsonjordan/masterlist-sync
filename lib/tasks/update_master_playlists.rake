
desc 'Update Masters Playlists On Spotify'
task update_master_playlists: :environment do
    User.find_each do |u|
        RSpotify::User.new(u.spotify_hash)
        u.master_playlists.each do |pl|
            pl.update_tracks
        end
    end
end