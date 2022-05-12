class UsersController < ApplicationController
  require 'json'

  def dashboard
    if JSON.parse(ENV["ApprovedUsers"]).include? current_user.id
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @minion = @user.minion_playlists.where("is_valid = ? and disabled = ?", "true", "false").order(:id)
    @master = @user.master_playlists.where(disabled: false).order(:id)
  end
end