class AddColumnsToExchangeRate < ActiveRecord::Migration[7.0]
  def change
    add_reference :exchange_rates, :created_by, null: false, foreign_key: { to_table: :admins }
    add_reference :exchange_rates, :approved_by, null: true, foreign_key: { to_table: :admins }
    add_reference :exchange_rates, :recused_by, null: true, foreign_key: { to_table: :admins }
    add_column :exchange_rates, :variation, :float, default: 0.0
  end
end
