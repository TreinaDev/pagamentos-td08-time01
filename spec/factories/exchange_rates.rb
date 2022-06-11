# frozen_string_literal: true

FactoryBot.define do
  factory :exchange_rate do
    brl_coin { %w[1.5 2.5].sample }
    register_date { %w[2022-07-09 2022-07-25].sample }
  end
end
