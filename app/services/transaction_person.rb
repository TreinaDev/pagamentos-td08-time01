# frozen_string_literal: true

class TransactionPerson
  def self.perform(cpf, client_transaction_params)
    cpf_formated = CpfValidator.perform(cpf)
    client = ClientPerson.find_by!(cpf: cpf_formated)

    client_transaction = ClientTransaction.new(client_transaction_params)
    client_transaction.status = :pending
    client_transaction.client_id = client.id
    client_transaction.transaction_date = Time.current.strftime('%d/%m/%Y - %H:%M')
    client_transaction.save!
  end
end
