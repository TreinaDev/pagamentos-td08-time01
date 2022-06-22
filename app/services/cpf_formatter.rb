# frozen_string_literal: true

class CpfFormatter
  def self.perform(cpf)
    CPF.new(cpf).formatted
  end
end
