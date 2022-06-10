class ChangeDefaultRubiCoin < ActiveRecord::Migration[7.0]
  def change
    change_column :exchange_rates, :rubi_coin, :integer, default: 1
  end
end
