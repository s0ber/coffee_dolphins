require 'routing_filters/helper_params'

Rails.application.routes.draw do
  get 'users/new'

  filter :helper_params

  root 'application#root'

  resources :positions, only: [:index]
  resources :landings, only: [:index]
  resource :statistics, only: [:show]
  resource :finances, only: [:show]

end
