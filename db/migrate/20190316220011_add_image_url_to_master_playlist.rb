class AddImageUrlToMasterPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_column :master_playlists, :image_url, :string
  end
end
