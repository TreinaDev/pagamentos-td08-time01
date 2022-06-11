class CreateClientCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :client_categories do |t|
      t.string :name
      t.float :discount_percent

      t.timestamps
    end
  end
end
