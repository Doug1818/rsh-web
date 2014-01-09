RshWeb::Application.routes.draw do
  resources :weeks

  namespace :api do
    namespace :v1 do
      resources :sessions
      resources :small_steps
      resources :users
      resources :weeks
      get 'week/by_date', to: 'weeks#by_date', as: :week_by_date
      resources :check_ins
      resources :programs
    end
  end

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

  resources :big_steps
  resources :small_steps
  resources :check_ins
  resources :activities
  resources :excuses
  resources :alerts
  resources :reminders
  resources :supporters
  resources :todos
  resources :leads

  root 'home#index'
end
