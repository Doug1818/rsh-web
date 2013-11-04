RshWeb::Application.routes.draw do

  resources :practices
  devise_for :coaches
  resources :coaches

  root 'home#index'
end
