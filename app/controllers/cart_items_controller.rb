# frozen_string_literal: true

# app/controllers/cart_items_controller.rb
class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    cart = current_user.cart || current_user.create_cart
    product = Product.find(params[:product_id])
    cart_item = cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity ||= 0
    cart_item.quantity += 1
    cart_item.save

    redirect_to cart_path(cart), notice: 'Product added to cart!'
  end

  def destroy
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.destroy

    redirect_to cart_path(current_user.cart), notice: 'Product removed from cart.'
  end
end
