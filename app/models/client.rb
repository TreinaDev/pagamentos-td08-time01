# frozen_string_literal: true

class Client < ApplicationRecord
  validates :client_type, presence: true
  enum client_type: { client_person: 0, client_company: 5 }

  belongs_to :client_category
  has_one :client_person, dependent: :destroy
  has_one :client_company, dependent: :destroy
  has_many :client_transactions, dependent: :destroy
  has_one :client_bonus_balance, dependent: :destroy

  accepts_nested_attributes_for :client_person, allow_destroy: true
  accepts_nested_attributes_for :client_company, allow_destroy: true
  accepts_nested_attributes_for :client_transactions, allow_destroy: true
end
