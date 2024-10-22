# frozen_string_literal: true

# searching
class SearchController < ApplicationController
  def index
    query = params[:q]
    category = params[:category]

    # Search for products matching the query
    @products = Product.where('name ILIKE ?', "%#{query}%")
    
    # If a category is selected, filter products by the category
    if category.present?
      @products = @products.joins(:category).where(categories: { c_name: category })
    end
  end
end
