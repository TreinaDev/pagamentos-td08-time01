# frozen_string_literal: true

FactoryBot.define do
  factory :client_company do
    company_name { Faker::Company.name }
    cnpj { CNPJ.generate }
    client { create(:client, client_type: 5) }
  end
end
