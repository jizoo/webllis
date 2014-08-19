Rails.application.routes.draw do

  namespace :editor do
    root 'posts#index'
    get 'login' => 'sessions#new', as: :login
    resource :session, only: [ :create, :destroy ]
    resources :posts do
      delete :delete, on: :collection
    end
  end

  namespace :admin do
    root 'static_pages#home'
    get 'login' => 'sessions#new', as: :login
    resource :session, only: [ :create, :destroy ]
    resources :users do
      resources :events, only: [ :index ]
    end
    resources :events, only: [ :index ]
    resources :allowed_sources, only: [ :index, :create ] do
      delete :delete, on: :collection
    end
  end

  root 'posts#index'
  get 'about' => 'static_pages#about', as: :about
  get 'contact' => 'contacts#new', as: :contact
  get 'login' => 'sessions#new', as: :login
  get 'signup' => 'users#new', as: :signup
  resources :feeds, only: :index do
    get :picked, on: :collection
  end
  resource :session, only: [ :create, :destroy ]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resource :password, only: [ :show, :edit, :update ]
  resources :posts do
    get :posted, :favorite, :picked, on: :collection
    resources :comments, only: [ :create, :destroy ] do
      post :confirm, on: :collection
      resource :reply, only: [ :new, :create ] do
        post :confirm
      end
    end
  end
  resources :comments, only: [ :index, :destroy ] do
    get :trashed, :count, on: :collection
    patch :trash, :recover, on: :member
  end
  resources :relationships, only: [ :create, :destroy ]
  resources :favorites, only: [ :index, :create, :destroy ]
  get 'tags/:tag' => 'feeds#index', as: :tag
  resources :password_resets, only: [ :new, :edit, :create, :update ]
  get '/auth/:provider/callback' => 'authentications#create'
  resources :authentications, only: [ :index, :create, :destroy ]
  resource :contacts, only: [ :new, :create ] do
    post :confirm, on: :collection
  end

  get '*anything' => 'errors#not_found'
end
