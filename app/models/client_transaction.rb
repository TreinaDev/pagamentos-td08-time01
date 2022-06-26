# frozen_string_literal: true

class ClientTransaction < ApplicationRecord
  belongs_to :client
  has_one :transaction_notification, dependent: :destroy

  validates :credit_value, :type_transaction, :transaction_date, :status, presence: true
  validates :credit_value, numericality: { greater_than: 0 }

  before_create :set_code

  enum status: { pending: 0, active: 5, refused: 10 }
  enum type_transaction: { buy_rubys: 0, transaction_order: 5, cashback: 10 }

  private

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase.insert(4, '-')
  end
end
