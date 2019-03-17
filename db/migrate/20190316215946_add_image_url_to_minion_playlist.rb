class AddImageUrlToMinionPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_column :minion_playlists, :image_url, :string
  end
end
