FactoryBot.define do
  factory :client_bonus_balance do
    bonus_value { Faker::Number.number(digits: 2) }
    expire_date { Faker::Date.between(from: Date.today, to: Date.today + 30.days) }
  end
end
