# frozen_string_literal: true

# db/migrate/20241009104014_add_image_to_category.rb
class AddImageToCategory < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :image, :text
  end
end
