# frozen_string_literal: true

class Promotion < ApplicationRecord
  belongs_to :client_category
  validates :name, :start_date, :end_date, :discount_percent, :limit_day, presence: true
  validates :start_date, comparison: { less_than: :end_date, message: 'deve ser menor que data de encerramento' }
  validates :start_date, comparison: { greater_than_or_equal_to: Time.zone.today, message: 'não pode ser no passado' }
  validates :start_date, :end_date, uniqueness: { scope: :client_category }
  validates :discount_percent, :limit_day, numericality: { greater_than_or_equal_to: 1 }
  validates :limit_day, numericality: { only_integer: true }
end
