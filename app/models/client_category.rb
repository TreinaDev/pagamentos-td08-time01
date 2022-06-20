# frozen_string_literal: true

class ClientCategory < ApplicationRecord
  validates :name, :discount_percent, presence: true
  validates :name, uniqueness: true

  has_many :promotions, dependent: :destroy
  has_many :clients, dependent: :destroy

  before_validation :set_category_name

  private

  def set_category_name
    self.name = name.capitalize if name.present?
  end
end
