# frozen_string_literal: true

class AddCodeToClientTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :client_transactions, :code, :string
    add_index :client_transactions, :code, unique: true
  end
end
