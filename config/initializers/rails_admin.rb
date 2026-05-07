RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    unless current_user && current_user.admin?
      flash[:alert] = "You are not authorized to access the admin dashboard."
      redirect_to main_app.root_path
    end
  end

  config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.model 'User' do
    list do
      include_fields :id, :email, :confirmed_at, :created_at
      scopes [nil, :all]
    end
  end

  config.model 'Setting' do
    label 'Site Settings'
    label_plural 'Site Settings'
    navigation_label 'Configuration'
    navigation_icon 'fa fa-cog'

    list do
      field :whatsapp_number
      field :whatsapp_message
      field :updated_at
    end

    edit do
      field :whatsapp_number do
        help 'WhatsApp number with country code, digits only (e.g. country code 91 followed by the 10-digit number). Leave blank to hide the chat button.'
      end
      field :whatsapp_message do
        help 'Optional. Pre-filled message when a visitor opens the chat.'
      end
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
