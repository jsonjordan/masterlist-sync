class AddMinionToMasterPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_reference :master_playlists, :minion_playlists, foreign_key: true
  end
end
