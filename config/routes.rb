Rails.application.routes.draw do

  namespace :admin do
    root 'static_pages#home'
    get 'login' => 'sessions#new', as: :login
    resource :session, only: [ :create, :destroy ]
    resources :users do
      resources :events, only: [ :index ]
    end
    resources :events, only: [ :index ]
  end

  root 'static_pages#home'
  get 'about' => 'static_pages#about', as: :about
  get 'contact' => 'static_pages#contact', as: :contact
  get 'login' => 'sessions#new', as: :login
  get 'signup' => 'users#new', as: :signup
  resource :session, only: [ :create, :destroy ]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resource :password, only: [ :show, :edit, :update ]
  resources :posts
  resources :relationships, only: [ :create, :destroy ]

  get '*anything' => 'errors#routing_error'
end
