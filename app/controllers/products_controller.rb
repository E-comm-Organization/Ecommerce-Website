# frozen_string_literal: true

# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_category, only: %i[index show new create edit update destroy], if: -> { params[:category_id].present? }
  skip_before_action :verify_authenticity_token, only: [:prices]
  load_and_authorize_resource # CanCanCan will handle loading and authorization
  def all_products
    @products = Product.all
  end

  def index
    @category = Category.find(params[:category_id])
    @products = @category.products
    @products = @category.products.page(params[:page]).per(12)
  end

  def show
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      @product = @category.products.find(params[:id])
    else
      @product = Product.find(params[:id])
      @category = @product.category  # This assumes you have a relationship in your Product model
    end
  end

  def new
    @category = Category.find(params[:category_id])
    @product = @category.products.new
  end

  def create
    @category = Category.find(params[:category_id])
    @product = @category.products.new(product_params)
    if @product.save
      redirect_to [@category, @product], notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:category_id])
    @product = @category.products.find(params[:id])
  end

  def update
    @category = Category.find(params[:category_id])
    @product = @category.products.find(params[:id])
    if @product.update(product_params)
      redirect_to [@category, @product], notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @product = @category.products.find(params[:id])
    @product.destroy
    redirect_to category_products_path(@category), notice: 'Product was successfully destroyed.'
  end

  def remove_image
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge_later
    redirect_to(fallback_location: request.referer)
  end

  def prices
    product_ids = params[:product_ids]
    products = Product.where(id: product_ids)
    prices = products.map(&:price)

    render json: { prices: prices }
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def product_params
    params.require(:product).permit(:name, :sku, :size, :price, :mrp, :description, :offer, :selling_price, images: [])
  end
end
