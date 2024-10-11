# frozen_string_literal: true

RailsAdmin.config do |config|
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## Admin-only access
  config.authorize_with do
    redirect_to main_app.root_path unless current_user&.admin?
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

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
  config.asset_source = :sprockets

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

    config.model 'Product' do
      edit do
        field :name
        field :sku
        field :size
        field :price
        field :mrp
        field :selling_price
        field :images, :multiple_active_storage # ActiveStorage for multiple image uploads
        field :category
      end
    end

    config.model 'Order' do
      create do
        configure :product_ids
        configure :user_id
        configure :total_amount
      end
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
