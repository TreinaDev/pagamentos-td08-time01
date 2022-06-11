class ClientCategory < ApplicationRecord
  validates :name, :discount_percent, presence: true
end
