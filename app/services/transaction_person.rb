# frozen_string_literal: true

class TransactionPerson
  def self.perform(cpf, client_transaction_params)
    cpf_formated = CpfFormatter.perform(cpf)
    client_person = ClientPerson.find_by!(cpf: cpf_formated)

    client_transaction = ClientTransaction.new(client_transaction_params)

    if client_transaction_params['type_transaction'] == 'buy_rubys'
      Check.transaction(client_transaction_params['credit_value'], client_person, client_transaction)
    end

    client_transaction.client_id = client_person.id
    client_transaction.transaction_date = Time.current.strftime('%d/%m/%Y - %H:%M')
    client_transaction.save!
  end
end
