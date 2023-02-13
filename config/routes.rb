Rails.application.routes.draw do
  resources :team_members 

  get 'contacts/new'
  get 'contacts/create'

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get "test" => "home#test"

  get "testimonials" => "testimonials#index"
  get "testimonials/new" => "testimonials#new"
  post "testimonials" => "testimonials#create"
  delete "testimonials/:id" => "testimonials#destroy"

  get "accommodation" => "accommodation#index"

  resources :blogs
  get "packages/new" => "packages#new" 
  get "packages" => "packages#index"
  get "packages/:id" => "packages#show", as: :package
  get "packages/:id/edit" => "packages#edit", as: :edit_package
  patch "packages/:id" => "packages#update"

  
  get "about" => "about#index"
  
  post "packages" => "packages#create"
  delete "packages/:id" => "packages#destroy", as: :destroy_package

  resources :gallery do
    delete 'destroy', on: :member, as: :destroy
  end
  get "galleries" => "gallery#new"
  post "galleries" => "gallery#create"

  resources :contacts, only: [:index, :new, :create]
  
end
