require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  get 'login', to: 'sessions#new', as: :login
  match '/auth/mixin/callback', to: 'sessions#create', via: [:get, :post]
  match '/auth/failure', to: 'sessions#failure', via: :get
  delete '/logout', to: 'sessions#destroy', as: :logout

  resources :posts do
    resources :payments, only: [:new, :create], controller: :post_payments
    resources :comments, only: [:new, :create, :edit, :update]
  end

  resource :payment_state, only: [:show]

  mount Sidekiq::Web => '/sidekiq'
  mount StatusPage::Engine => '/'
  #mount ActionCable.server => '/cable'
  root to: 'home#index'
end
