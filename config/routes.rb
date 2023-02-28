Rails.application.routes.draw do
  resources :team_members 

  get 'contacts/new'
  get 'contacts/create'

  get 'bookings' => 'bookings#index', as: :bookings
  post 'bookings' => 'bookings#create'
  get 'bookings_list' => 'bookings#bookings_list'

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get "test" => "home#test"

  get "testimonials" => "testimonials#index"
  get "testimonials/new" => "testimonials#new"
  post "testimonials" => "testimonials#create"
  delete "testimonials/:id" => "testimonials#destroy"


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

  resources :contacts, only: [:index, :create]

  # config/routes.rb
  # config/routes.rb


  direct :rails_public_blob do |blob|
    # Preserve the behaviour of `rails_blob_url` inside these environments
    # where S3 or the CDN might not be configured
    if Rails.env.development? || Rails.env.test?
      route_for(:rails_blob, blob)
    else
      # Use an environment variable instead of hard-coding the CDN host
      # You could also use the Rails.configuration to achieve the same
      File.join(Rails.application.credentials.cloudfront[:host], blob.key)
    end
  end

  
end
