class Client < ApplicationRecord
  validates :client_type, presence: true
  enum client_type: ["Pessoa física", "Pessoa jurídica"]
end