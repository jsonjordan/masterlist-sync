class RemoveMasterfromMinionPlayist < ActiveRecord::Migration[5.2]
  def change
    remove_reference :master_playlists, :minion_playlists, foreign_key: true
  end
end
