# frozen_string_literal: true

class EcommerceResponseMsg
  def self.message(status)
    case status
    when 200
      'O status da transação foi atualizado com sucesso.'
    when 404
      'Transação desconhecida pelo E-commerce.'
    when 422
      'Tipo de erro em branco.'
    when 500
      'Alguma coisa deu errado, por favor contate o suporte do E-commerce.'
    end
  end
end
