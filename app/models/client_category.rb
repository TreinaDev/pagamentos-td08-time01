# frozen_string_literal: true

class ClientCategory < ApplicationRecord
  validates :name, :discount_percent, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  has_many :promotions, dependent: :destroy
  has_many :clients, dependent: :destroy
end
