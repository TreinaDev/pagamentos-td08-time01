# frozen_string_literal: true

class CreateTransactionNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_notifications do |t|
      t.text :description, null: false
      t.references :client_transaction, null: false, foreign_key: true

      t.timestamps
    end
  end
end
