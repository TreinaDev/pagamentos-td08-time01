# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins

  root 'home#index'

  resources :admin_permissions, only: %i[create]
  resources :client_categories, only: %i[index new create]

  resources :exchange_rates, only: %i[index new create show] do
    post 'recused', on: :member
    post 'approved', on: :member
  end

  resources :promotions, only: %i[index new create]

  namespace :api do
    namespace :v1 do
      resources :client_companies, only: %i[create]
      resources :client_people, only: %i[create]
    end
  end

  get '/pendencies', to: 'pendencies#index'
end
