# frozen_string_literal: true

class Admin < ApplicationRecord
  has_many :admin_permissions, dependent: :destroy

  enum status: { pending: 0, active: 5 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :exchange_rates, foreign_key: 'created_by', class_name: 'ExchangeRate', dependent: :nullify,
                            inverse_of: :created_by
  validates :full_name,
            :cpf, presence: true

  validates :email, format: { with: /@userubis\.com\.br\z/,
                              message: 'deve possuir o dominio @userubis.com.br' }

  validates :cpf, uniqueness: true

  validate :cpf_validator

  private

  def cpf_validator
    if CPF.valid?(cpf, strict: true) == true
      register_id = CPF.new(cpf)
      self.cpf = register_id.formatted
    else
      errors.add(:cpf, 'não é válido')
    end
  end
end
