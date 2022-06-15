# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { "#{Faker::Alphanumeric.alpha(number: 6)}@userubis.com.br" }
    password { Faker::Internet.password }
    full_name { Faker::Name.name }
    cpf { CPF.generate }
  end
end
