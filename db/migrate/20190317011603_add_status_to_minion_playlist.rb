class AddStatusToMinionPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_column :minion_playlists, :is_valid, :boolean, :default => true
    add_column :minion_playlists, :disabled, :boolean, :default => false
  end
end
