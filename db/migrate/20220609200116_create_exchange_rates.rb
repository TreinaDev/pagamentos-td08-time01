class CreateExchangeRates < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_rates do |t|
      t.float :rubi_coin
      t.float :brl_coin
      t.date :register_date
      t.integer :status

      t.timestamps
    end
  end
end
