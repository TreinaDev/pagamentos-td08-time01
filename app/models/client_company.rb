# frozen_string_literal: true

class ClientCompany < ApplicationRecord
  validates :company_name, :cnpj, presence: true
  validates :cnpj, uniqueness: true

  belongs_to :client

  validate :cnpj_validator

  private

  def cnpj_validator
    if CNPJ.valid?(cnpj, strict: true) == true
      register_id = CNPJ.new(cnpj)
      self.cnpj = register_id.formatted
    else
      errors.add(:cnpj, 'não é válido')
    end
  end
end
