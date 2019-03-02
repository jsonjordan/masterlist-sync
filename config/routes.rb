Rails.application.routes.draw do

  root 'home#home'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/users/user/:id' => 'users#show', :as => 'user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
