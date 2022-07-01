# frozen_string_literal: true

FactoryBot.define do
  factory :exchange_rate do
    brl_coin { rand(1..10) }
    register_date { Time.zone.today }
  end
end
