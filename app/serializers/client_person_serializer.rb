# frozen_string_literal: true

class ClientPersonSerializer < ActiveModel::Serializer
  attributes :client_info

  def client_info
    {
      name: object.full_name,
      balance: object.client.balance,
      bonus: client_bonus,
      transactions: transaction_history
    }
  end

  def transaction_history
    object.client.client_transactions.last(30).map do |transaction|
      {
        credit_value: transaction.credit_value,
        type_transaction: transaction.type_transaction,
        transaction_date: transaction.transaction_date.strftime('%d/%m/%Y ás %H:%M'),
        status: transaction.status,
        approval_date: transaction.approval_date&.strftime('%d/%m/%Y ás %H:%M'),
        code: transaction.code
      }
    end
  end

  def client_bonus
    object.client.client_bonus_balances.where('expire_date >= ?', Time.zone.today).map do |bonus|
      { bonus_value: bonus.bonus_value, expire_date: bonus.expire_date }
    end
  end
end
