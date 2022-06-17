class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.float :bonus
      t.integer :limit_day
      t.references :client_category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :promotions, [:start_date, :client_category_id], unique: true
  end
end
