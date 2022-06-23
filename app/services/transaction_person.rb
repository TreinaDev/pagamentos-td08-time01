# frozen_string_literal: true

class TransactionPerson
  def self.perform(cpf, transaction_params)
    cpf_formated = CpfFormatter.perform(cpf)
    client_person = ClientPerson.find_by!(cpf: cpf_formated)

    client_transaction = ClientTransaction.new(transaction_params)
    client_transaction.client_id = client_person.id
    client_transaction.transaction_date = Time.current.strftime('%d/%m/%Y - %H:%M')

    if client_transaction.buy_rubys?
      Check.transaction(transaction_params['credit_value'], client_person, client_transaction)
    end

    client_transaction.save!
  end
end
