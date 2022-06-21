class CreateClientTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :client_transactions do |t|
      t.decimal :credit_value
      t.integer :type_transaction
      t.datetime :transaction_date, default: 0
      t.references :client, null: false, foreign_key: true
      t.integer :status, default: 0
      t.datetime :approval_date, default: nil

      t.timestamps
    end
  end
end
