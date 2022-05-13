class AddMissingAlphatunezLettersToMasterPlaylists < ActiveRecord::Migration[5.2]
  def change
    add_column :master_playlists, :missing_alphatunez_letters, :json
  end
end
