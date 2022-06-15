# frozen_string_literal: true

class TransactionSetting < ApplicationRecord
  validates :max_credit, presence: true
  validates :max_credit, numericality: { greater_than_or_equal_to: 0 }
end
