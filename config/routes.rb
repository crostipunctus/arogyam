Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :blog
  get "packages/new" => "packages#new" 
  get "packages" => "packages#index"
  get "packages/:id" => "packages#show", as: :package
  get "packages/:id/edit" => "packages#edit"
  patch "packages/:id" => "packages#update"

  get "contact" => "contact#index"
  get "about" => "about#index"
  
  post "packages" => "packages#create"

end
