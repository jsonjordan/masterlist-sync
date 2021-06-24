class MinionPlaylistsController < ApplicationController

    def make_setlist
        minion = current_user.minion_playlists.find(params[:playlists_id])
        new_master = minion.make_master
        if new_master.present? && new_master.spotify_master&.total > 0
            flash[:success] = "#{new_master.name} successfully created!"
        elsif new_master.present? && new_master.spotify_master.present?
            flash[:error] = "#{new_master.name} was created, but is empty.  See help for possible solutions."
        else
            flash[:error] = "A Master for #{minion.name} could not be created :("
        end
        redirect_to current_user
    end

end
