# frozen_string_literal: true

FactoryBot.define do
  factory :transaction_notification do
    description { Faker::Lorem.paragraph }
    client_transaction
  end
end
