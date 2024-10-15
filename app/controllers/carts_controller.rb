# frozen_string_literal: true

# carts_controller.rb
# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart || current_user.create_cart
  end

  def stripe_checkout
    @cart = current_user.cart

    if @cart.cart_items.empty?
      redirect_to cart_path(@cart), alert: 'Your cart is empty.'
      return
    end

    # Use environment variable for API key in production
    Stripe.api_key = 'sk_test_51Q8KMiP6KW88waI4BybHjSyIhh6WjTVyL24cEOcnIM7XJJLbRZN5lZUKRpX57gbI4tnqqFib4zyWmxIY3bSa1Ekz001Bf0JslD' # Ensure this is set in your environment

    session = Stripe::Checkout::Session.create({
                                                 payment_method_types: ['card'],
                                                 line_items: @cart.cart_items.map do |item|
                                                   {
                                                     price_data: {
                                                       currency: 'inr',
                                                       product_data: {
                                                         name: item.product.name
                                                       },
                                                       unit_amount: (item.product.selling_price * 100).to_i # Amount in paise
                                                     },
                                                     quantity: item.quantity
                                                   }
                                                 end,
                                                 mode: 'payment',
                                                 success_url: success_cart_url, # Make sure this route is defined
                                                 cancel_url: cancel_cart_url # Make sure this route is defined
                                               })

    puts "Stripe session URL: #{session.url}" # Debugging line to log the session URL

    # Redirect to Stripe checkout
    redirect_to session.url, allow_other_host: true
  end

  def success
    @cart = current_user.cart
    order = build_order
    send_order_confirmation
    add_products_to_order(order)

    # Create a new order for the user
    order = Order.new(user: current_user)

    add_products_to_order(order)

    order.total_amount = @cart.cart_items.sum { |item| item.product.selling_price * item.quantity }
    if order.save
      # Clear the cart after the order is created
      @cart.cart_items.destroy_all

      # Redirect to the order details page
      redirect_to order_path(order), notice: 'Payment successful! Your order has been placed.'
    else
      redirect_to cart_path(@cart), alert: 'There was an issue creating your order.'
    end
  end

  def cancel
    redirect_to cart_path(current_user.cart), alert: 'Payment canceled.'
  end

  private

  def build_order
    Order.new(user: current_user)
  end

  def send_order_confirmation
    OrderMailer.with(user: current_user, article: @cart).order_confirmation.deliver_now
  end

  def add_products_to_order(order)
    @cart.cart_items.each do |item|
      order.products << item.product
    end
  end
end
