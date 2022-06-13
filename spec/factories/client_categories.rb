# frozen_string_literal: true

FactoryBot.define do
  factory :client_category do
    name { Faker::Games::ClashOfClans.rank }
    discount_percent { Faker::Number.decimal(l_digits: 2) }
  end
end
