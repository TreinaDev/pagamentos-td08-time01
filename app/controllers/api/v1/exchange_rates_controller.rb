# frozen_string_literal: true

class Api::V1::ExchangeRatesController < Api::ApiController
  def search
    if params[:register_date].nil?
      render status: :bad_request,
             json: { message: 'Não foi possível fazer busca, é necessário uma data como parâmetro' }
    elsif search_approved_exchange_rate
      render status: :ok, json: @exchange_rate, only: %i[brl_coin register_date]
    else
      render status: :not_found,
             json: { message:
                    'Não foi encontrada taxa de câmbio disponível. Entre em contato com a API de Pagamento' }
    end
  end

  private

  def search_approved_exchange_rate
    @exchange_rate = nil
    4.times do |day|
      @exchange_rate = ExchangeRate.find_by(register_date: params[:register_date].to_date - day.days,
                                            status: 'approved')
      break if @exchange_rate.present?
    end
    @exchange_rate
  end
end
