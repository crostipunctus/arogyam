Rails.application.routes.draw do
  resources :team_members 

  get 'contacts/new'
  get 'contacts/create'

  get 'bookings' => 'bookings#index'

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

  resources :contacts, only: [:index, :new, :create]

  # config/routes.rb
  # config/routes.rb
direct :cdn_image do |model, options|
  expires_in = options.delete(:expires_in) { ActiveStorage.urls_expire_in }

  if model.respond_to?(:signed_id)
    route_for(
      :rails_service_blob_proxy,
      model.signed_id(expires_in: expires_in),
      model.filename,
      options.merge(host: Rails.application.credentials.cloudfront[:host])
    )
  else
    signed_blob_id = model.blob.signed_id(expires_in: expires_in)
    variation_key  = model.variation.key
    filename       = model.blob.filename

    route_for(
      :rails_blob_representation_proxy,
      signed_blob_id,
      variation_key,
      filename,
      options.merge(host: Rails.application.credentials.cloudfront[:host])
    )
  end
end


  
end
