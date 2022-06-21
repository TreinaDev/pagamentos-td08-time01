# frozen_string_literal: true

class CpfValidator
  def self.perform(cpf)
    CPF.valid?(cpf, strict: true)

    register_id = CPF.new(cpf)
    register_id.formatted
  end
end
