# frozen_string_literal: true

class ClientCompany < ApplicationRecord
  validates :company_name, :cnpj, presence: true

  belongs_to :client
end
