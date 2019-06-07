Rails.application.routes.draw do
  root to: 'pages#home'

  get '/users' => 'users#dashboard', as: :user_root # creates user_root_path
  get '/user' => 'user#dashboard'
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  post '/user/:id', to: 'users#dashboard'
  patch '/users/:id', to: 'users#update', as: :update_user


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end


  resources :users
  resources :user_groups, only: [:new, :create]

  resources :groups, only: [:show, :create, :update, :edit, :index] do
    resources :polls, only: [:create]
  end

  resources :polls, only: [:show] do
    resources :votes, only: [:create]
  end
end
