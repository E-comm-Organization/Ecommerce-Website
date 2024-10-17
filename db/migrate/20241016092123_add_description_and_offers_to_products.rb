class AddDescriptionAndOffersToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :description, :text
    add_column :products, :offers, :text
  end
end
