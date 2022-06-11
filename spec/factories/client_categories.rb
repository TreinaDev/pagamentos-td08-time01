# frozen_string_literal: true

FactoryBot.define do
  factory :client_category do
    name { 'MyString' }
    discount_percent { 1.5 }
  end
end
