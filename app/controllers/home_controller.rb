# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_admin!
  def index
    @client_transactions_count = ClientTransaction.where(status: :pending).count
    @admin_count = Admin.where(status: 0).count

    if ExchangeRate.where(status: 'approved').any?
      @exchange_rate = ExchangeRate.where(status: 'approved').last.rubi_coin
    else
      @exchange_rate = 'Sem cadastro'
    end
  end
end
