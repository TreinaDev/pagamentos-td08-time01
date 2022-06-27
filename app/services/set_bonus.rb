# frozen_string_literal: true

class SetBonus
  def self.promotions(client, transaction)
    promotions = client.client_category.promotions

    valid_promotions = promotions.select do |promotion|
      transaction.transaction_date.between?(promotion.start_date.beginning_of_day, promotion.end_date.end_of_day)
    end

    valid_promotions.each do |promotion|
      client_bonus_params = { bonus_value: (transaction.credit_value * promotion.bonus) / 100,
                              expire_date: transaction.transaction_date + promotion.limit_day.days }

      client.client_bonus_balances.create!(client_bonus_params)
    end
  end
end
