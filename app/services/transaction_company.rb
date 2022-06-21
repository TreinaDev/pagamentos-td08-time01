# frozen_string_literal: true

class TransactionCompany
  def self.perform(cnpj, client_transaction_params)
    cnpj_formated = CnpjValidator.perform(cnpj)
    client = ClientCompany.find_by!(cnpj: cnpj_formated)

    client_transaction = ClientTransaction.new(client_transaction_params)
    client_transaction.status = :pending
    client_transaction.client_id = client.id
    client_transaction.transaction_date = DateTime.current
    client_transaction.save!
    client_transaction
  end
end
