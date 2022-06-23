# frozen_string_literal: true

class SummingTransaction
  def self.sum(client_type, _value)
    today_transactions = client_type.client.client_transactions.where('created_at > ?', 24.hours.ago)
    today_transactions.sum(&:credit_value) + _value
  end
end
