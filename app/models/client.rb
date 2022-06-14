# frozen_string_literal: true

class Client < ApplicationRecord
  validates :client_type, presence: true
  enum client_type: { client_person: 0, client_company: 5 }

  belongs_to :client_category
  has_many :client_people, dependent: :destroy
  has_many :client_companies, dependent: :destroy
end
