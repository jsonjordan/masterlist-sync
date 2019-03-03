class MinionPlaylist < ApplicationRecord

    validates :name, presence: true
    validates :spotify_id, presence: true

    belongs_to :master_playlists, optional: true
    belongs_to :user

end
