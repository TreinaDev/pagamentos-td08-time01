# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { "#{Faker::Alphanumeric.alpha(number: 6)}@userubis.com.br" }
    password { Faker::Internet.password }
    full_name { Faker::Name.name }
    cpf { Faker::IDNumber.brazilian_citizen_number(formatted: true) }
  end
end
