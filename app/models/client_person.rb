# frozen_string_literal: true

class ClientPerson < ApplicationRecord
  validates :full_name, :cpf, presence: true
  validates :cpf, uniqueness: true
  belongs_to :client

  validate :cpf_validator

  private

  def cpf_validator
    if CPF.valid?(cpf, strict: true) == true
      register_id = CPF.new(cpf)
      self.cpf = register_id.formatted
    else
      errors.add(:cpf, 'não é válido')
    end
  end
end
