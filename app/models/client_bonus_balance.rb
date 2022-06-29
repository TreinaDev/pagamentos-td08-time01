# frozen_string_literal: true

class ClientBonusBalance < ApplicationRecord
  belongs_to :client

  validates :bonus_value, :expire_date, presence: true
  validates :bonus_value, numericality: { greater_than_or_equal_to: 0 }

  validate :ensure_expire_date_is_not_in_the_past

  def ensure_expire_date_is_not_in_the_past
    return unless expire_date

    errors.add(:expire_date, 'não pode ser no passado') if expire_date < Time.zone.today
  end
end
