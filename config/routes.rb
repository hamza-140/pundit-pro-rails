require 'sidekiq/web'
Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
    end
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'projects#index'
  get '/projects/bugs', to: 'projects#bugs'
  get '/projects/users', to: 'projects#users'

  resources :projects do
    resources :bugs
  end

  match "*path", to: "errors#not_found", via: :all
end
