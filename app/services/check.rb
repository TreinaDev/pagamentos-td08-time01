# frozen_string_literal: true

class Check
  def self.transaction(value, client_type, transaction)
    return if (SummingTransaction.sum(client_type, value.to_f)) > TransactionSetting.last.max_credit

    transaction.active!
    client = client_type.client
    client.update(balance: client.balance += value.to_f)
    transaction.approval_date = Time.current.strftime('%d/%m/%Y - %H:%M')

    SetBonus.promotions(client, transaction)
  end
end
