class CreateMinionPlaylist < ActiveRecord::Migration[5.2]
  def change
    create_table :minion_playlists do |t|
      t.string :name
      t.string :spotify_id
      t.references :master_playlist, foreign_key: true
    end
  end
end
