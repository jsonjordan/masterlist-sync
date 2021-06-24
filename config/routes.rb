Rails.application.routes.draw do

  root 'home#home'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/user/:id/dashboard' => 'users#dashboard', :as => 'user'
  get '/setlist/:playlist_name' => 'master_playlists#show'
  post '/minion/:playlists_id' => 'minion_playlists#make_setlist'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
