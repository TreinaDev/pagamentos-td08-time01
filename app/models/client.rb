class Client < ApplicationRecord
    validates :client_type, presence: true
    validates :client_type, inclusion: {in: ["Pessoa física", "Pessoa jurídica"]}
end