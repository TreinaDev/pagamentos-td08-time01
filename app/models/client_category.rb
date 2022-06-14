# frozen_string_literal: true

class ClientCategory < ApplicationRecord
  validates :name, :discount_percent, presence: true
  has_many :clients
end
