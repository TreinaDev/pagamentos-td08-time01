# frozen_string_literal: true

require 'rails_helper'

describe 'API pagaments' do
  context 'when GET /api/v1/exchange_rates/search' do
    it 'with success' do
      admin = create(:admin)
      create(:exchange_rate, register_date: Time.zone.today,
                             status: 'approved', brl_coin: 5.12, created_by: admin)

      params = { register_date: Time.zone.today }
      get "/api/v1/exchange_rates/search/?register_date=#{params[:register_date]}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['brl_coin']).to eq 5.12
    end

    it 'when exchange rate status is pending returns the last approved' do
      admin = create(:admin)
      create(:exchange_rate, brl_coin: 5, register_date: Time.zone.today, created_by: admin)
      exchange_rate = create(:exchange_rate, register_date: Time.zone.tomorrow,
                                             status: 'pending', brl_coin: 6, created_by: admin)

      params = { register_date: exchange_rate.register_date }
      get "/api/v1/exchange_rates/search/?register_date=#{params[:register_date]}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['brl_coin']).to eq 5
    end

    it 'when exchange rate is not found on the last 4 days' do
      params = { register_date: Time.zone.today }
      get "/api/v1/exchange_rates/search/?register_date=#{params[:register_date]}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      message = 'Não foi encontrada taxa de câmbio disponível. Entre em contato com a API de Pagamento'
      expect(json_response['message']).to eq message
    end

    it 'when regiter_date was not deliveried' do
      admin = create(:admin)
      create(:exchange_rate, register_date: Time.zone.today,
                             status: 'approved', brl_coin: 5.12, created_by: admin)

      get '/api/v1/exchange_rates/search/'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(json_response['message']).to eq 'Não foi possível fazer busca, é necessário uma data como parâmetro'
    end
  end
end
