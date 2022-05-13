desc 'Update Masters Playlists Stats'
task update_master_playlists_stats: :environment do
    spotify_user_id = ''
    MasterPlaylist.includes(:user).find_each do |pl|
        unless (spotify_user_id == pl.user.id)
            RSpotify::User.new(pl.user.spotify_hash)
            spotify_user_id = pl.user.id
        end
        pl.set_stats
    end
end