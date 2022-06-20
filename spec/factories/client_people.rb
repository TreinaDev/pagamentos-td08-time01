# frozen_string_literal: true

FactoryBot.define do
  factory :client_person do
    full_name { Faker::Name.name }
    cpf { CPF.generate }
  end
end
