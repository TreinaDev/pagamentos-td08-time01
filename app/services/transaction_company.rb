# frozen_string_literal: true

class TransactionCompany
  def self.perform(cnpj, transaction_params)
    cnpj_formated = CNPJ.new(cnpj).formatted
    client_company = ClientCompany.find_by!(cnpj: cnpj_formated)

    client_transaction = ClientTransaction.new(transaction_params)
    client_transaction.client_id = client_company.id
    client_transaction.transaction_date = Time.current.strftime('%d/%m/%Y - %H:%M')

    if can_buy_rubis?(client_transaction, client_company, transaction_params['credit_value'].to_f)
      BuyRubys.perform(transaction_params['credit_value'].to_f, client_company.client, client_transaction)
    end

    client_transaction.save!
    client_transaction
  end

  def self.can_buy_rubis?(client_transaction, client_company, value)
    return true if TransactionSetting.last.nil?

    client_transaction.buy_rubys? && (SummingTransaction.sum(client_company,
                                                             value)) <= TransactionSetting.last.max_credit
  end
end
