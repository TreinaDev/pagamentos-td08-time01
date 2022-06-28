# frozen_string_literal: true

module ApplicationHelper
  CLIENT_TRANSACTION_STATUS = [
    ['Aprovar', :approved],
    ['Recusar', :refused]
  ].freeze

  def options_for_client_transaction_status(selected)
    options_for_select(CLIENT_TRANSACTION_STATUS, selected)
  end
end

# convert rubi to brl into client_transaction index
def search_approved_exchange_rate(transaction_date)
  exchange_rate = nil
  4.times do |day|
    exchange_rate = ExchangeRate.find_by(register_date: transaction_date.to_date - day.days,
                                         status: 'approved')
    break if exchange_rate.present?
  end
  exchange_rate
end
