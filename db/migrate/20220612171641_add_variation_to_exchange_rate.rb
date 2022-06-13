class AddVariationToExchangeRate < ActiveRecord::Migration[7.0]
  def change
    add_column :exchange_rates, :variation, :float, default: 0.0
  end
end
