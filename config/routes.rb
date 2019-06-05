Rails.application.routes.draw do
  root to: 'pages#home'


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }


  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get '/dashboard', to: 'users#dashboard', as: 'dashboard'

  resources :user_groups, only: [:create]

  resources :groups, only: [:show, :create, :update, :edit, :index] do
    resources :polls, only: [:create]
  end

  resources :polls, only: [:show] do
    resources :votes, only: [:create]
  end
end
