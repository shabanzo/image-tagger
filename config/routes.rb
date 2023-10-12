Rails.application.routes.draw do
  devise_for :users
  resources :images
  resources :tags, only: %i[index show new create]

  root 'images#index'
end
