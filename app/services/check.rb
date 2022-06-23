# frozen_string_literal: true

class Check
  def self.transaction(value, client_type, transaction)
    return if (SummingTransaction.sum(client_type, value.to_f)) > TransactionSetting.last.max_credit

    transaction.status = :active
    client_type.client.balance += value.to_f
    client_type.client.save
    transaction.approval_date = Time.current.strftime('%d/%m/%Y - %H:%M')
  end
end
