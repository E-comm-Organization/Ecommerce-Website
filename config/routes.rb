# frozen_string_literal: true

Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_for :users

  resources :services
  root to: 'home#index'
  get 'all_products', to: 'products#all_products', as: 'all_products'
  post 'products/prices', to: 'products#prices'
  resources :customers, only: %i[new create index]

  resources :categories do
    resources :products
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

  resources :products do
    member do
      delete :remove_image
    end
  end
end
