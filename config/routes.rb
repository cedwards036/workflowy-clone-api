Rails.application.routes.draw do
  resources :nodes, only: [:show, :update, :destroy]
  resources :lists, only: [:show, :create] do
    resources :nodes, only: [:create]
    resources :tags, only: [:index]
  end
  resources :tags, only: [:show, :create]
end
