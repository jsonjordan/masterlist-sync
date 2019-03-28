
desc 'Update Masters Playlists On Spotify'
task update_master_playlists: :environment do
    MasterPlaylist.find_each do |pl|
        RSpotify::User.new(pl.user.spotify_hash)
        pl.update_tracks
    end
end