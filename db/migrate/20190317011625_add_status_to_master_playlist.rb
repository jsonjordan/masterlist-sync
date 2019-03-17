class AddStatusToMasterPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_column :master_playlists, :disabled, :boolean, :default => false
  end
end
