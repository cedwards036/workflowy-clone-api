Rails.application.routes.draw do
  resources :nodes, only: [:show, :create, :update, :destroy]
  resources :lists, only: [:show, :create] do
    resources :tags, only: [:index]
  end
  resources :tags, only: [:show, :create]
end
