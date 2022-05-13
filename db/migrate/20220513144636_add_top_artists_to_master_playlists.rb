class AddTopArtistsToMasterPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :master_playlists, :top_artists, :json
  end
end
