# frozen_string_literal: true

class TransactionPerson
  def self.perform(cpf, transaction_params)
    cpf_formated = CpfFormatter.perform(cpf)
    client_person = ClientPerson.find_by!(cpf: cpf_formated)

    client_transaction = ClientTransaction.new(transaction_params)
    client_transaction.client_id = client_person.id
    client_transaction.transaction_date = Time.current.strftime('%d/%m/%Y - %H:%M')

    if can_buy_rubis?(client_transaction, client_person, transaction_params['credit_value'].to_f)
      Check.transaction(transaction_params['credit_value'].to_f, client_person, client_transaction)
    end

    client_transaction.save!
    client_transaction
  end

  def self.can_buy_rubis?(client_transaction, client_person, value)
    return true if TransactionSetting.last.nil?
    client_transaction.buy_rubys? && (SummingTransaction.sum(client_person, value)) <= TransactionSetting.last.max_credit
  end
end
