# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins

  root 'home#index'

  resources :admin_permissions, only: %i[create]

  get '/pendencies', to: 'pendencies#index'
end
