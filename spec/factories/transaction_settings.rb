# frozen_string_literal: true

FactoryBot.define do
  factory :transaction_setting do
    max_credit { Faker::Number.within(range: 30_000..50_000) }
  end
end
