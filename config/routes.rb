Rails.application.routes.draw do
  root 'home#index'

  resources :exchange_rates, only: %i[index new create]
end
