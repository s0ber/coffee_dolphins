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

    scope module: :positions do
      resources :notes, only: [:create]
    end
  end

  resources :categories
  resources :landings, only: [:index]
  resource :statistics, only: [:show]
  resource :finances, only: [:show]
  resources :users

  scope module: :polymorphic do
    resources :notes, only: [:show, :edit, :update, :destroy]
  end
end
