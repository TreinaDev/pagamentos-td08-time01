class ExchangeRatesController < ApplicationController
  def index
    @exchange_rates = ExchangeRate.all
  end

  def new
    @exchange_rate = ExchangeRate.new
  end

  def create
    @exchange_rate = ExchangeRate.new(get_er_params)

    if @exchange_rate.save
      redirect_to exchange_rates_path, notice: 'Taxa de câmbio registrada com sucesso'
    else
      flash.now[:alert] = "Erro ao registrar taxa de câmbio"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def get_er_params
    params.require(:exchange_rate).permit(:register_date, :brl_coin)
  end

end