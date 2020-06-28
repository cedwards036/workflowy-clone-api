Rails.application.routes.draw do
  resources :nodes, only: [:show, :create, :update, :destroy]
  resources :lists, only: [:show] do
    resources :tags, only: [:index, :show]
  end
end
