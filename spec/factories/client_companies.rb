# frozen_string_literal: true

FactoryBot.define do
  factory :client_company do
    company_name { Faker::Company.industry }
    cnpj { CNPJ.generate }
  end
end
