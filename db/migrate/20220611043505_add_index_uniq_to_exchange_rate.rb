class AddIndexUniqToExchangeRate < ActiveRecord::Migration[7.0]
  def change
    add_index :exchange_rates, :register_date, unique: true
  end
end
