class UsersController < ApplicationController
  
    def show
      @user = User.find params[:id]
      @playlists = RSpotify::User.find(@user.uid).playlists
    end
  end