class AddReferenceToExchangeRate < ActiveRecord::Migration[7.0]
  def change
    add_reference :exchange_rates, :created_by, null: true, foreign_key: { to_table: :admins }
  end
end
