# frozen_string_literal: true

FactoryBot.define do
  factory :client_bonus_balance do
    bonus_value { Faker::Number.number(digits: 2) }
    expire_date { 3.weeks.from_now }
  end
end
