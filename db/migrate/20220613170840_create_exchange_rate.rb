class CreateExchangeRate < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_rates do |t|
      t.integer :rubi_coin, default: 1
      t.float :brl_coin
      t.date :register_date
      t.integer :status
      
      t.timestamps
    end

    add_index :exchange_rates, :register_date, unique: true
  end
end
