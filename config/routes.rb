Rails.application.routes.draw do
  get 'profiles/show'
  resources :team_members 

  get 'contacts/new'
  get 'contacts/create'

  get 'online_consultations' => 'bookings#index', as: :online_consultations
  post 'bookings' => 'bookings#create'
  get 'bookings_list' => 'bookings#bookings_list'

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  resources :users, only: [] do
    resource :profile, controller: 'user_profiles'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get "test" => "home#test"

  get "testimonials" => "testimonials#index"
  get "testimonials/new" => "testimonials#new"
  post "testimonials" => "testimonials#create"
  delete "testimonials/:id" => "testimonials#destroy"

  get "announcements" => "announcements#index"
  get "announcements/new" => "announcements#new"
  post "announcements" => "announcements#create"
  get "packages/:id/edit" => "announcements#edit", as: :edit_announcement
  patch "announcements/:id" => "announcements#update", as: :update_announcement 
  delete "announcements/:id" => "announcements#destroy", as: :delete_announcement

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

  resources :contacts, only: [:index, :create]

  resources :batches 

  resources :registrations 
  
  get 'pdf' => 'registrations#pdf'

  get 'batch/:id' => 'batches#pdf', as: :batch_pdf

  


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
