# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  MAX_VARIATION = 10
  before_create :set_status_exchange_rate

  validates :brl_coin, :register_date, presence: true
  validates :brl_coin, numericality: { greater_than: 0 }

  validate :ensure_private_rates_have_unique_dates, on: :create
  validate :ensure_register_date_is_not_in_the_past
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
    return unless ExchangeRate.all.empty? || max_variation?

    self.status = 'approved'
    self.approved_by = created_by
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

  def ensure_register_date_is_not_in_the_past
    return unless register_date

    errors.add(:register_date, 'não pode ser no passado') if register_date < Time.zone.today
  end

  def ensure_private_rates_have_unique_dates
    query = ExchangeRate.where('register_date == :today AND status != :recused',
                               { today: Time.zone.today, recused: 10 }).any?
    return unless query

    errors.add(:register_date, 'já está em uso')
  end
end
