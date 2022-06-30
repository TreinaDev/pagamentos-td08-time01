# frozen_string_literal: true

class Check
  def self.and_buy(transaction, status)
    status = TransactionConfirmation.send_response(transaction.code, status).status

    BuyProducts.perform(transaction, transaction.client) if status == 200

    status
  end

  def self.and_refuse(transaction, status, description)
    status = send(transaction, status)
    transaction_notification_params = { description: description, client_transaction: transaction }

    if status == 200
      TransactionNotification.create!(transaction_notification_params)
      transaction.refused!
    end

    status
  end

  def self.can_buy_products?(transaction)
    client = transaction.client
    bonus = Discounts.filter_client_bonus(client, transaction).sum(&:bonus_value)
    category_discount = (transaction.credit_value * client.client_category.discount_percent) / 100

    transaction.update!(credit_value: transaction.credit_value - category_discount)

    (transaction.client.balance + bonus) >= transaction.credit_value.to_f
  end

  def self.send(transaction, status)
    TransactionConfirmation.send_response(transaction.code, status, 'fraud_warning').status
  end
end
