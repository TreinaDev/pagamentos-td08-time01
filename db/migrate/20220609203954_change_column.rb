class ChangeColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :exchange_rates, :rubi_coin, :integer
  end
end
