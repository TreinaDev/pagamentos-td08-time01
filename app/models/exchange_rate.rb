# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  MAX_VARIATION = 10
  before_create :set_status_exchange_rate

  validates :brl_coin, :register_date, presence: true
  validates :brl_coin, numericality: { greater_than: 1 }
  validates :register_date, uniqueness: true
  validates :register_date,
            comparison: { greater_than_or_equal_to: Time.zone.today, message: 'não pode ser no passado' }

  validate :prevent_approvemment_by_creator, on: :update, unless: :recused?
  validate :prevent_recuse_by_nil, on: :update, unless: :approved?

  belongs_to :created_by, class_name: 'Admin'
  belongs_to :approved_by, class_name: 'Admin', optional: true
  belongs_to :recused_by, class_name: 'Admin', optional: true

  enum status: { pending: 0, approved: 5, recused: 10 }, _default: :pending

  def max_variation?
    calc_variation <= MAX_VARIATION
  end

  private

  def set_status_exchange_rate
    if ExchangeRate.all.empty? || max_variation?
      self.status = 'approved' 
      self.approved_by = created_by
    end
  end

  def calc_variation
    return if ExchangeRate.approved.count < 1

    self.variation =
      ((brl_coin - ExchangeRate.approved.last.brl_coin) / ExchangeRate.approved.last.brl_coin * 100).ceil(2)
  end

  def prevent_approvemment_by_creator
    if approved_by.nil? 
      errors.add(:exchange_rate, 'não pode ser aprovada sem um administrador')
    elsif approved_by == created_by && variation > MAX_VARIATION
      errors.add(:exchange_rate,
                 'não pode ser aprovada pelo mesmo administrador que registrou')
    end
  end

  def prevent_recuse_by_nil
    errors.add(:exchange_rate, 'não pode ser recusada sem um administrador') if recused_by.nil?
  end
end
