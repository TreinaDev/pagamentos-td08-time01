# frozen_string_literal: true

class BuyProducts
  def self.perform(transaction, client)
    transaction_value = find_and_use_bonus(transaction, client)
    client.update!(balance: client.balance - transaction_value)
    transaction.approved!
    transaction.approval_date = Time.current.strftime('%d/%m/%Y - %H:%M')
  end

  def self.find_and_use_bonus(transaction, client)
    transaction_value = transaction.credit_value.to_f

    Discounts.filter_client_bonus(client, transaction).each do |bonus|
      if bonus.bonus_value >= transaction_value
        bonus.bonus_value -= transaction_value
        transaction_value = 0
      else
        transaction_value -= bonus.bonus_value
        bonus.bonus_value = 0
      end

      bonus.save!
    end

    transaction_value
  end
end
