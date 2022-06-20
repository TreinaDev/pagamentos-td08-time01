# frozen_string_literal: true

FactoryBot.define do
  factory :client_bonus_balance do
    bonus_value { Faker::Number.number(digits: 2) }
    expire_date { Faker::Date.between(from: Time.zone.today, to: Time.zone.today + 30.days) }
  end
end
