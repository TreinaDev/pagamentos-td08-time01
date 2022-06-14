FactoryBot.define do
  factory :promotion do
    name { "MyString" }
    start_date { "2022-06-14" }
    end_date { "2022-06-14" }
    discount_percent { 1.5 }
    limit_dats { 1 }
    client_category { nil }
  end
end
