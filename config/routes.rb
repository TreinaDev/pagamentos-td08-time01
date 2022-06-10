Rails.application.routes.draw do
  root 'home#index'

  resources :client_categories, only: [:index, :new, :create]
end
