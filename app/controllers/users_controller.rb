class UsersController < ApplicationController

  def dashboard
    @user = User.find(params[:id])
    @minion = @user.minion_playlists.where("is_valid = ? and disabled = ?", "true", "false").order(:id)
    @master = @user.master_playlists.where(disabled: false).order(:id)
  end
end