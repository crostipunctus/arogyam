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

  get 'contacts/new'
  get 'contacts/create'
  

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
  get "programmes/new" => "packages#new", as: :new_programme 
  get "programmes" => "packages#index", as: :programmes
  get "programme/:id" => "packages#show", as: :programme 
  get "programme/:id/edit" => "packages#edit", as: :edit_package
  patch "programme/:id" => "packages#update" 

  
  get "about" => "about#index"
  get "donate" => "donations#index", as: :donate
  
  post "packages" => "packages#create"
  delete "packages/:id" => "packages#destroy", as: :destroy_package

  resources :gallery do
    delete 'destroy', on: :member, as: :destroy
  end
  get "galleries" => "gallery#new"
  post "galleries" => "gallery#create"

  resources :contacts, only: [:index, :create]


  resources :registrations do
    collection do
      get :export_batch
      get :export_vishraam
      get :review
      post :confirm
      get :pdf
    end
  end
  
  get 'pdf' => 'registrations#pdf'

  

  resources :vishraam_registrations do 
    collection do 
      get :review 
      post :confirm 
    end 
  end 

  get 'vishraam_pdf' => 'vishraam_registrations#pdf'

  get 'privacy_policy', to: 'privacy_policy#index', as: :privacy_policy

  resources :newsletter_subscriptions, only: [:create]



  # config/routes.rb
  # config/routes.rb


  # Builds a direct CloudFront URL for an Active Storage attachment OR a variant.
  # In development/test, falls back to standard Active Storage routes so the
  # site works without S3/CDN configured.
  direct :rails_public_blob do |source|
    if Rails.env.development? || Rails.env.test?
      if source.respond_to?(:variation)
        route_for(:rails_blob_representation,
                  source.blob.signed_id,
                  source.variation.key,
                  source.blob.filename)
      else
        route_for(:rails_blob, source)
      end
    else
      # `processed` triggers variant generation on first access (sync) and is
      # a no-op once the variant exists in S3. For plain attachments, .key is
      # the blob's storage key directly.
      key = source.respond_to?(:processed) ? source.processed.key : source.key
      File.join(Rails.application.credentials.cloudfront[:host], key)
    end
  end

  
end
