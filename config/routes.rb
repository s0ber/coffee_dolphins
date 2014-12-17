require 'routing_filters/helper_params'

Rails.application.routes.draw do
  filter :helper_params

  root 'application#root'

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'

  resources :sessions, only: [:new, :create, :destroy]

  scope module: :public do
    categories = ->(req) { Category.where(slug: req.params[:category]).any? }
    get '/:category' => 'categories#show', as: :public_category, constraints: categories
    get '/:category/:landing' => 'landings#show', as: :public_landing, constraints: categories
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
    resources :landings, only: [:index, :new, :create, :update, :destroy]
    resource :statistics, only: [:show]
    resource :finances, only: [:show]
    resources :users

    scope module: :polymorphic do
      resources :notes, only: [:show, :edit, :update, :destroy]
    end
  end
end
