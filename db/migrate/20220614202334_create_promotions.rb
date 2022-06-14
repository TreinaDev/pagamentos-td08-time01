class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.float :discount_percent
      t.integer :limit_days
      t.references :client_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
