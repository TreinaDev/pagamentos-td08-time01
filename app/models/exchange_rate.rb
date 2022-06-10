class ExchangeRate < ApplicationRecord
  validates :brl_coin, :register_date, presence: true
end
