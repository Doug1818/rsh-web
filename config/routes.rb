RshWeb::Application.routes.draw do
  resources :practices
  devise_for :coaches
  resources :coaches
  devise_for :users
  resources :users

  resources :programs
  resources :alerts

  root 'home#index'
end
