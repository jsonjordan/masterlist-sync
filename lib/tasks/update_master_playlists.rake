
desc 'Update Masters Playlists On Spotify'
task update_master_playlists: :environment do
    spotify_user_id = ''
    MasterPlaylist.includes(:user).find_each do |pl|
        unless (spotify_user_id == pl.user.id)
            RSpotify::User.new(pl.user.spotify_hash)
            spotify_user_id = pl.user.id
        end
        pl.update_tracks
    end
end