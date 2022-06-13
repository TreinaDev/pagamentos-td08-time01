# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins
  root 'home#index'

  resources :client_categories, only: %i[index new create]
  namespace :api do
    namespace :v1 do
      resources :client_people, only: %i[create]
    end
  end
  resources :exchange_rates, only: %i[index new create]
end
