# frozen_string_literal: true

class ClientPerson < ApplicationRecord
  validates :full_name, :cpf, presence: true
  belongs_to :client
end
