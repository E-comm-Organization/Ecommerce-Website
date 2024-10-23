class AddFieldToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :description, :text
    add_column :products, :offer, :string
  end
end
