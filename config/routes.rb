Rails.application.routes.draw do
  resources :users, only: [:create, :show, :index]
  resources :invites, only: [:create]
end
