# frozen_string_literal: true

class CreateTransactionSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_settings do |t|
      t.decimal :max_credit, null: false

      t.timestamps
    end
  end
end
