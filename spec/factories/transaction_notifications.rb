# frozen_string_literal: true

FactoryBot.define do
  factory :transaction_notification do
    description {}
    client_transaction { nil }
  end
end
