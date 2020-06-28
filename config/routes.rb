Rails.application.routes.draw do
  resources :nodes, only: [:show, :create, :update, :destroy]
end
