Rails.application.routes.draw do
  resources :messages, only: [:create]
  resources :users, only: [:index, :show, :create] do
    resources :messages, only: [:index]
  end 
end
