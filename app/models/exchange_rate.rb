# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  MAX_VARIATION = 10
  before_create :set_status_exchange_rate

  validates :brl_coin, :register_date, presence: true
  validates :brl_coin, numericality: { greater_than: 1 }
  validates :register_date, uniqueness: true
  validate :register_date_is_future

  belongs_to :created_by, class_name: "Admin", optional: true
 
  enum status: { pending: 0, approved: 5, recused: 10 }

  def max_variation?
    calc_percent < MAX_VARIATION
  end

  private

  def register_date_is_future
    errors.add(:register_date, 'deve ser futura') if register_date.present? && register_date < Time.zone.today
  end

  def set_status_exchange_rate
    self.status = if ExchangeRate.all.empty? || max_variation?
                    'approved'
                  else
                    'pending'
                  end
  end

  def calc_percent
    (brl_coin - ExchangeRate.approved.last.brl_coin) / ExchangeRate.approved.last.brl_coin * 100
  end
end
