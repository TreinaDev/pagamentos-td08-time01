FactoryBot.define do
  factory :exchange_rate do
    rubi_coin { 1.5 }
    brl_coin { 1.5 }
    register_date { "2022-06-09" }
    status { 1 }
  end
end
