# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins

  root 'home#index'

  resources :admin_permissions, only: %i[create]
  resources :client_categories, only: %i[index new create]
  resources :transaction_settings, only: %i[new create edit update]

  resources :exchange_rates, only: %i[index new create show] do
    post 'recused', on: :member
    post 'approved', on: :member
  end

  resources :promotions, only: %i[index new create]
  resources :client_transactions, only: %i[index edit update]

  namespace :api do
    namespace :v1 do
      post '/clients_info', to: 'clients#info'
      resources :clients, only: %i[create]
      resources :client_transactions, only: %i[create]
    end
  end

  get '/pendencies', to: 'pendencies#index'
end
