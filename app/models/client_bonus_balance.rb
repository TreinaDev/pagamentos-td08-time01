class ClientBonusBalance < ApplicationRecord
  belongs_to :client

  validates :bonus_value, :expire_date, presence: true
  validates :bonus_value, comparison: { greater_than_or_equal_to: 0 }
  validates :expire_date, comparison: { greater_than_or_equal_to: Time.zone.today, message: 'não pode ser no passado' }
end
