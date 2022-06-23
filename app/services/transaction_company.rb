# frozen_string_literal: true

class TransactionCompany
  def self.perform(cnpj, transaction_params)
    cnpj_formated = CnpjFormatter.perform(cnpj)
    client_company = ClientCompany.find_by!(cnpj: cnpj_formated)

    client_transaction = ClientTransaction.new(transaction_params)
    client_transaction.client_id = client_company.id
    client_transaction.transaction_date = Time.current.strftime('%d/%m/%Y - %H:%M')

    if client_transaction.buy_rubys?
      Check.transaction(transaction_params['credit_value'], client_company, client_transaction)
    end

    client_transaction.save!
  end
end
