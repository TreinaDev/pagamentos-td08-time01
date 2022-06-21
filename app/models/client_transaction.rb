# frozen_string_literal: true

class ClientTransaction < ApplicationRecord
  belongs_to :client
  validates :credit_value, :type_transaction, :transaction_date, :status, presence: true
  validates :credit_value, numericality: { greater_than: 0 }

  enum status: { pending: 0, active: 5, refused: 10 }
  enum type_transaction: { buy_rubys: 0, transaction_order: 5 }
end
