require 'routing_filters/helper_params'

Rails.application.routes.draw do
  filter :helper_params

  root 'application#root'

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  resources :sessions, only: [:new, :create, :destroy]

  resources :positions do
    collection do
      get :prepare_import
      get :favorite
      post :import
    end

    member do
      get :cut
      put :like
      put :unlike
    end
  end

  resources :landings, only: [:index]
  resource :statistics, only: [:show]
  resource :finances, only: [:show]
  resources :users
end
