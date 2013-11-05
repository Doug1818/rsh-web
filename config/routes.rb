RshWeb::Application.routes.draw do

  resources :programs

  devise_for :users
  resources :users

  devise_for :coaches
  resources :coaches

  resources :practices

  root 'home#index'
end
