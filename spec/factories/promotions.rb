# frozen_string_literal: true

FactoryBot.define do
  factory :promotion do
    name { Faker::Name.name }
    start_date { I18n.l(Faker::Date.forward(days: 30)) }
    end_date { I18n.l(Faker::Date.forward(days: 60)) }
    bonus { Faker::Number.decimal(l_digits: 2) }
    limit_day { Faker::Number.number(digits: 2) }
    client_category { create(:client_category) }
  end
end
