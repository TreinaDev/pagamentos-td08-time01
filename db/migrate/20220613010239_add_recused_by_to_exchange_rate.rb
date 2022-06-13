class AddRecusedByToExchangeRate < ActiveRecord::Migration[7.0]
  def change
    add_reference :exchange_rates, :recused_by, null: true, foreign_key: { to_table: :admins }
  end
end
