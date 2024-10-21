# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  after_initialize :set_default_role, if: :new_record?
  has_many :orders

  enum role: { customer: 'customer', salesperson: 'salesperson', admin: 'admin' }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true

  def cart
    Cart.find_or_create_by(user_id: id)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(
      email: data['email'],
      password: Devise.friendly_token[0, 20]
    )
    user
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
