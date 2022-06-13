# frozen_string_literal: true

class ExchangeRatesController < ApplicationController
  before_action :authenticate_admin!, only: %i[new create]

  def index
    @exchange_rates = ExchangeRate.approved.last(15)
  end

  def new
    @exchange_rate = ExchangeRate.new
  end

  def create
    @exchange_rate = ExchangeRate.new(er_params)

    if @exchange_rate.save
      verify_status
    else
      flash.now[:alert] = 'Erro ao registrar taxa de câmbio'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def er_params
    params.require(:exchange_rate).permit(:register_date, :brl_coin)
  end

  def verify_status
    if @exchange_rate.pending?
      redirect_to exchange_rates_path, alert: 'Taxa de câmbio em análise'
    else
      redirect_to exchange_rates_path, notice: 'Taxa de câmbio registrada com sucesso'
    end
  end
end
