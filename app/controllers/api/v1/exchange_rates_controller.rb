# frozen_string_literal: true

class Api::V1::ExchangeRatesController < Api::ApiController
  def show
    if search_approved_exchange_rate
      render status: :ok, json: @exchange_rate, only: %i[brl_coin register_date]
    else
      render status: :internal_server_error,
             json: { message: 'Não foi encontrada taxa de câmbio disponível, entre em contato' }
    end
  end

  private

  def search_approved_exchange_rate
    @exchange_rate = nil
    4.times do |days|
      @exchange_rate = ExchangeRate.find_by(register_date: params[:register_date].to_date - days.days,
                                            status: 'approved')
      break if @exchange_rate.present?
    end
    @exchange_rate
  end
end
