class SearchController < ApplicationController
  def index
    query = params[:q]
    @products = Product.where('name ILIKE ? OR description ILIKE ?', "%#{query}%", "%#{query}%")
  end
end