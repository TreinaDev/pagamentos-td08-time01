# frozen_string_literal: true

class CheckExchangeRateValid
  def self.perform
    exchange_rate = nil

    4.times do |day|
      exchange_rate = ExchangeRate.find_by(register_date: Time.zone.now.to_date - day.days,
                                           status: 'approved')
      break if exchange_rate.present?
    end

    exchange_rate
  end
end
