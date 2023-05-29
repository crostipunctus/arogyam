Rails.application.routes.draw do
  require 'sidekiq/web'
 
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'privacy_policy/index'
  get 'newsletter_subscriptions/create'
  get 'profiles/show'
  resources :team_members 

  patch 'payment_complete/:id' => 'online_consultations#payment_complete', as: :payment_complete


  get 'contacts/new'
  get 'contacts/create'

  resources :online_consultations do
    resource :case_sheet, only: [:show, :new, :create, :edit, :update, :destroy]
  end
  
  post 'online_consultations/:id/reschedule' => 'online_consultations#reschedule', as: :reschedule_online_consultation

  get 'all_online_consultations' => 'online_consultations#all'
  resources :booking_dates
  

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

  

  resources :registrations do
    collection do
      get :export_batch
      get :export_vishraam
    end
  end
  
  get 'pdf' => 'registrations#pdf'

  get 'batch/:id' => 'batches#pdf', as: :batch_pdf

  resources :vishraam_registrations

  get 'vishraam_pdf' => 'vishraam_registrations#pdf'

  get 'privacy_policy', to: 'privacy_policy#index', as: :privacy_policy

  resources :newsletter_subscriptions, only: [:create]




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
