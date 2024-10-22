# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  get 'services/about', to: 'services#about'
  get 'services/service', to: 'services#service'
  get 'services/policy', to: 'services#policy'
  get 'services/faq', to: 'services#faq'
  get 'services/career', to: 'services#career'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users,
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  resources :services
  root to: 'home#index'
  get 'all_products', to: 'products#all_products', as: 'all_products'
  post 'products/prices', to: 'products#prices'
  resources :customers, only: %i[new create index]

  get 'search', to: 'search#index', as: 'search'
  # Add a route to access all products

  resources :categories do
    resources :products do
      member do
        delete :destroy
      end
    end
  end
  resources :products do
    resources :orders
  end

  resources :categories, only: %i[index show] do
    get 'products', to: 'home#show_category_products', as: 'show_products'
  end

  # Add a route to access all products

  resources :orders do
    member do
      get 'generate_pdf'
    end
  end

  resource :cart, only: [:show] do
    get 'stripe_checkout', to: 'carts#stripe_checkout'
    post 'stripe_checkout', to: 'carts#stripe_checkout' # POST for checkout
    get 'success', to: 'carts#success'
    get 'cancel', to: 'carts#cancel'
  end

  resources :cart_items, only: %i[create destroy]
  resources :orders, only: [:show]

  resources :products do
    member do
      delete :remove_image
    end
  end
end

# rubocop:enable Metrics/BlockLength
