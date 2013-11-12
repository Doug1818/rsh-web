RshWeb::Application.routes.draw do
  resources :practices
  devise_for :coaches
  resources :coaches
  devise_for :users
  resources :users

  resources :programs
  get 'programs/new_big_steps/:id', to: 'programs#new_big_steps', as: :new_big_steps
  patch 'programs/update_big_steps/:id', to: 'programs#update_big_steps', as: :update_big_steps
  get 'programs/new_small_steps/:id', to: 'programs#new_small_steps', as: :new_small_steps
  patch 'programs/update_small_steps/:id', to: 'programs#update_small_steps', as: :update_small_steps

  resources :small_steps
  resources :big_steps
  resources :alerts
  resources :reminders
  resources :supporters
  resources :todos

  root 'home#index'
end
