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

  root 'static_pages#home'
  get 'about' => 'static_pages#about', as: :about
  get 'contact' => 'contacts#new', as: :contact
  get 'editor_feed' => 'static_pages#editor_feed', as: :editor_feed
  get 'login' => 'sessions#new', as: :login
  get 'signup' => 'users#new', as: :signup
  resource :session, only: [ :create, :destroy ]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resource :password, only: [ :show, :edit, :update ]
  resources :posts do
    resources :comments, only: [ :create, :destroy ]
  end
  resources :relationships, only: [ :create, :destroy ]
  resources :favorites, only: [ :index, :create, :destroy ]
  get 'tags/:tag' => 'static_pages#home', as: :tag
  resources :password_resets, only: [ :new, :edit, :create, :update ]
  get '/auth/:provider/callback' => 'authentications#create'
  resources :authentications, only: [ :index, :create, :destroy ]
  resource :contacts, only: [ :new, :create ] do
    post :confirm, on: :collection
  end

  get '*anything' => 'errors#routing_error'
end
