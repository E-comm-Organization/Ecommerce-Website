# frozen_string_literal: true

# searching
class SearchController < ApplicationController
  def index
    query = params[:q]
    @products = Product.where('name ILIKE ?', "%#{query}%")
  end
end
