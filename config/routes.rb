# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins
  root 'home#index'

  resources :exchange_rates, only: %i[index new create]
  resources :client_categories, only: %i[index new create]
end
