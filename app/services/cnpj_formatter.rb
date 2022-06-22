# frozen_string_literal: true

class CnpjFormatter
  def self.perform(cnpj)
    CNPJ.new(cnpj).formatted
  end
end
