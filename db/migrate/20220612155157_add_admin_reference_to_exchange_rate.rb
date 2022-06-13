class AddAdminReferenceToExchangeRate < ActiveRecord::Migration[7.0]
  def change
    add_reference :exchange_rates, :created_by, null: false, foreign_key: { to_table: :admins }
  end
end
