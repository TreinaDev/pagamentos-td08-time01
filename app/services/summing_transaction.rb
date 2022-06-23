# frozen_string_literal: true

class SummingTransaction
  def self.sum(client_type, value)
    today_transactions = client_type.client.client_transactions.where('created_at > ?', 24.hours.ago)
    today_transactions.sum(&:credit_value) + value
  end
end
