class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

    def spotify
        @user = User.from_omniauth(request.env["omniauth.auth"])

        if @user
            sign_in @user
            @user.update_playlist_list
            set_flash_message(:notice, :success, kind: "Spotify") if is_navigational_format?
            redirect_to @user
        else
            flash[:error] = "Could not be logged in, try again"
            redirect_to root_path
        end
    end

    def failure
        redirect_to root_path
    end

end