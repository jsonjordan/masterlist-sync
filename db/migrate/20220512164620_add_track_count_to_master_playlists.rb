class AddTrackCountToMasterPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :master_playlists, :track_count, :integer
  end
end
