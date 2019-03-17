class MasterPlaylistsController < ApplicationController

    def show
        @master = current_user.master_playlists.find_by(name: params[:playlist_name])
    end

end
