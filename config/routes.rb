Rails.application.routes.draw do
  get 'chats/index'
  get 'chats/new'
  get 'chats/create'
  get 'chats/show'
  get 'chatrooms/index'
  get 'chatrooms/new'
  get 'chatrooms/create'
  get 'chatrooms/show'
  root to: 'pages#home'

  get '/users' => 'users#dashboard', as: :user_root # creates user_root_path
  get '/user' => 'user#dashboard'
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  post '/user/:id', to: 'users#dashboard'
  patch '/users/:id', to: 'users#update', as: :update_user
  patch '/user_groups/:id', to: 'user_groups#update', as: :update_user_group

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end


  resources :users
  resources :user_groups, only: [:new, :create, :update]

  resources :groups, only: [:show, :create, :update, :edit, :index] do
    resources :polls, only: [:create]
  end

  resources :polls, only: [:show] do
    resources :votes, only: [:create]
  end

  resources :chatrooms
  resources :chats

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
