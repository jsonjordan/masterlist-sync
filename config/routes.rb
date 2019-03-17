Rails.application.routes.draw do

  root 'home#home'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/users/user/:id' => 'users#show', :as => 'user'
  get '/master/:playlist_name' => 'master_playlists#show'
  post '/minion/:playlists_id' => 'minion_playlists#make_master'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
