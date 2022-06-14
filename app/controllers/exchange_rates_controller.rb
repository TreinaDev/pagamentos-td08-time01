# frozen_string_literal: true

class ExchangeRatesController < ApplicationController
  before_action :authenticate_admin!, only: %i[new create show approved recused]
  before_action :set_admin, only: %i[new create]
  before_action :set_exchange_rate, only: %i[show recused approved]

  def index
    if admin_signed_in?
      @exchange_rates = ExchangeRate.all
    else
      @approved_exchange_rates = ExchangeRate.approved.last(30)
    end
  end

  def new
    @exchange_rate = @admin.exchange_rates.new
  end

  def create
    @exchange_rate = @admin.exchange_rates.new(er_params)

    if @exchange_rate.save
      verify_status
    else
      flash.now[:alert] = 'Erro ao registrar taxa de câmbio'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def approved
    if current_admin == @exchange_rate.created_by
      redirect_to @exchange_rate, alert: 'Taxa não pode ser aprovada pelo mesmo administrador que registrou'
    else
      @exchange_rate.approved_by = current_admin
      @exchange_rate.approved!
      redirect_to @exchange_rate, notice: 'Taxa aprovada com sucesso'
    end
  end

  def recused
    @exchange_rate.recused_by = current_admin
    @exchange_rate.recused!
    redirect_to @exchange_rate, alert: 'Taxa recusada com sucesso'
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

  def set_admin
    @admin = current_admin
  end

  def set_exchange_rate
    @exchange_rate = ExchangeRate.find(params[:id])
  end
end
