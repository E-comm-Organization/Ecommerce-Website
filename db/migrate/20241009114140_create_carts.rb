# frozen_string_literal: true

# db/migrate/20241009114140_create_carts.rb
class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
