RshWeb::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  namespace :api do
    namespace :v1 do
      resources :sessions
      resources :small_steps
      resources :users
      resources :weeks
      resources :excuses
      get 'week/small_steps_for_day', to: 'weeks#small_steps_for_day', as: :small_steps_for_day
      resources :check_ins
      resources :programs
    end
  end

  resources :practices
  devise_for :coaches, controllers: { registrations: "coaches" }
  resources :coaches
  devise_for :users
  resources :users

  resources :programs
  get 'programs/new_big_steps/:id', to: 'programs#new_big_steps', as: :new_big_steps
  patch 'programs/update_big_steps/:id', to: 'programs#update_big_steps', as: :update_big_steps
  get 'programs/new_small_steps/:id', to: 'programs#new_small_steps', as: :new_small_steps
  patch 'programs/update_small_steps/:id', to: 'programs#update_small_steps', as: :update_small_steps

  resources :big_steps
  resources :small_steps do
    resources :note
    resources :attachments
  end
  resources :weeks
  resources :check_ins
  resources :activities
  resources :excuses
  resources :alerts
  resources :reminders
  resources :supporters
  resources :todos
  resources :leads
  resources :referrals

  root 'home#index'

  get "/coach_terms", to: 'legal_docs#coach_terms'
  get "/user_terms", to: 'legal_docs#user_terms'
  get "/privacy", to: 'legal_docs#privacy'
  get "support", to: 'home#support'

  get "/rshadmin", to: 'rshadmin#index'
end
