# frozen_string_literal: true

# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @categories = Category.all
  end

  def show_category_products
    @category = Category.find(params[:category_id])
    @products = @category.products
  end
end
