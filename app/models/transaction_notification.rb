# frozen_string_literal: true

class TransactionNotification < ApplicationRecord
  belongs_to :client_transaction

  validates :description, presence: true
end
