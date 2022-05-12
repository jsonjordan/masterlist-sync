class AddLastSongAddedToMasterPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :master_playlists, :last_song_added, :string
  end
end
