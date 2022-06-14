# frozen_string_literal: true

class Client < ApplicationRecord
  validates :client_type, presence: true
  enum client_type: { client_person: 0, client_company: 5 }
end
