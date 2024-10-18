# frozen_string_literal: true

# for taking offers field input
class AddDescriptionAndOfferToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :offer, :string
  end
end
