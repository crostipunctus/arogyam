Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :blog

  get "packages" => "packages#index"
  get "packages/:id" => "packages#show", as: :package
end
