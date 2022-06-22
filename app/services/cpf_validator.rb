# frozen_string_literal: true

class CpfValidator
  def self.perform(cpf)
    CPF.new(cpf).formatted
  end
end
