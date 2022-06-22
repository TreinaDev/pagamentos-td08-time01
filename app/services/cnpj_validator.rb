# frozen_string_literal: true

class CnpjValidator
  def self.perform(cnpj)
    CNPJ.new(cnpj).formatted
  end
end
