class AddUserReferenceToMinionPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_reference :minion_playlists, :user, foreign_key: true
  end
end
