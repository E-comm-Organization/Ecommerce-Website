# frozen_string_literal: true
# Adding
class AddDescriptionAndOfferToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :description, :text
    add_column :products, :offer, :text
  end
end