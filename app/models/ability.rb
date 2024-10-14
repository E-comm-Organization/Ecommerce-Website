# frozen_string_literal: true

# app/models/ability.rb
class Ability
  include CanCan::Ability

  # Allow user to be nil
  def initialize(user = nil)
    if user.nil? # Check if user is nil (guest)
      guest_permissions
    elsif user.admin?
      admin_permissions
    elsif user.salesperson?
      salesperson_permissions
    elsif user.customer?
      customer_permissions(user)
    end
  end

  private

  def admin_permissions
    can :manage, :all # Admins can manage everything
  end

  def salesperson_permissions
    can :read, Product
    can :manage, Order
    can :read, Category
    can :all_products, Product
    can :generate_pdf, Order
  end

  def customer_permissions(user)
    can :read, Product
    can :read, Category
    can :all_products, Product
    can :create, Order
    can :read, Order, user_id: user.id # Customers can only see their own orders
    cannot %i[create update], [Product, Category]
    can :generate_pdf, Order
  end

  def guest_permissions
    can :read, Product
    can :read, Category
  end
end
