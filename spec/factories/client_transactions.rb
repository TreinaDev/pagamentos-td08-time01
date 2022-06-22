# frozen_string_literal: true

FactoryBot.define do
  factory :client_transaction do
    credit_value { Faker::Number.decimal(l_digits: 2) }
    type_transaction { 0 }
    transaction_date { DateTime.now.strftime('%d/%m/%Y - %H:%M') }
    client
    status { 0 }
    approval_date { nil }
  end
end
