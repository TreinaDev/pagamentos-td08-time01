# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins
  root 'home#index'

  resources :client_categories, only: [:index, :new, :create]
end
