# frozen_string_literal: true

class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  has_many :exchange_rates, :foreign_key => "created_by", :class_name => "ExchangeRate" 

  validates :full_name,
            :cpf, presence: true

  validates :email, format: { with: /@userubis\.com\.br\z/,
                              message: 'deve possuir o dominio @userubis.com.br' }
end
