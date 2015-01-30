require 'routing_filters/helper_params'

Rails.application.routes.draw do
  filter :helper_params

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'

  resources :sessions, only: [:new, :create, :destroy]

  scope module: :public do
    root 'pages#home'

    landings = ->(req) { Landing.where(slug: req.params[:landing]).any? }
    # get '/:category' => 'categories#show', as: :public_category, constraints: categories
    get '/:landing' => 'landings#show', as: :public_landing, constraints: landings
    get '/:landing/images' => 'landings#images', as: :public_landing_images, constraints: landings
    get '/:landing/success' => 'landings#success', as: :public_landing_success, constraints: landings
    get '/:landing/success_modal' => 'landings#success_modal', as: :public_landing_success_modal, constraints: landings
    get '/privacy' => 'pages#privacy'
    get '/about' => 'pages#about'
    get '/delivery' => 'pages#delivery'
    get '/guarantees' => 'pages#guarantees'
    get '/faq' => 'pages#faq'
  end

  scope module: :admin do
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

    resources :landings do
      post :upload_image, on: :member
      put :reorder_images, on: :member
    end

    resource :statistics, only: [:show]
    resource :finances, only: [:show]
    resources :users

    scope module: :polymorphic do
      resources :notes, only: [:show, :edit, :update, :destroy]
    end
  end
end
