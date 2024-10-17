class AddDescriptionAndOfferToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :offer, :string
  end
end
