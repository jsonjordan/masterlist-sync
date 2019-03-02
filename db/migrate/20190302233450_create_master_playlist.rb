class CreateMasterPlaylist < ActiveRecord::Migration[5.2]
  def change
    create_table :master_playlists do |t|
      t.string :name
      t.string :spotify_id
      t.references :user, foreign_key: true
    end
  end
end
