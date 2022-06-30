# frozen_string_literal: true

class BuyRubys
  def self.perform(value, client, transaction)
    transaction.approved!
    client.update(balance: client.balance += value.to_f)
    transaction.approval_date = Time.current.strftime('%d/%m/%Y - %H:%M')

    Discounts.promotions(client, transaction)
  end
end
