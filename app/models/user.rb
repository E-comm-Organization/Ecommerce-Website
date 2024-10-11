# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
   has_one :cart, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_initialize :set_default_role, if: :new_record?
  has_many :orders

  enum role: { customer: 'customer', salesperson: 'salesperson', admin: 'admin' }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true


    def cart
    Cart.find_or_create_by(user_id: self.id)
  end

  private

  def set_default_role
    self.role ||= :customer
  end
end

# def admin?
#   role == 'admin'
# end

# def customer?
#   role == 'customer'
# end

# def salesperson?
#   role == 'salesperson'
# end
