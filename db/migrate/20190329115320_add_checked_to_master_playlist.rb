class AddCheckedToMasterPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_column :master_playlists, :last_checked, :date
    add_column :master_playlists, :last_updated, :date
  end
end
