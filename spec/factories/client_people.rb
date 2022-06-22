# frozen_string_literal: true

FactoryBot.define do
  factory :client_person do
    full_name { Faker::Name.name }
    cpf { CPF.generate }
    client { create(:client, client_type: 0) }
  end
end
