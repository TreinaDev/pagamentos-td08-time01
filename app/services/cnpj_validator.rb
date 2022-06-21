# frozen_string_literal: true

class CnpjValidator
  def self.perform(cnpj)
    CNPJ.valid?(cnpj, strict: true)

    register_id = CNPJ.new(cnpj)
    register_id.formatted
  end
end
