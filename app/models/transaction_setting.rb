# frozen_string_literal: true

class TransactionSetting < ApplicationRecord
  validates :max_credit, presence: true
  validates :max_credit, numericality: { greater_than: 0 }
end
