# frozen_string_literal: true

# app/models/category.rb
class Category < ApplicationRecord
  has_many :products
  has_one_attached :image # Ensure this is singular: :image
  has_many :products, dependent: :destroy
  validates :c_name, :c_size, presence: true
end
