# frozen_string_literal: true

require 'rails_helper'

describe 'API pagaments' do
  context 'when GET /api/v1/exchage_rate' do
    it 'with success' do
      admin = create(:admin)
      exchange_rate = create(:exchange_rate, register_date: Time.zone.today,
                                             status: 'approved', brl_coin: 5.12, created_by: admin)

      get "/api/v1/exchange_rates/#{exchange_rate.register_date}"
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

      get "/api/v1/exchange_rates/#{exchange_rate.register_date}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['brl_coin']).to eq 5
    end

    it 'when exchange rate is not found on the last 4 days' do
      get "/api/v1/exchange_rates/#{Time.zone.today}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      expect(json_response['message']).to eq 'Não foi encontrada taxa de câmbio disponível, entre em contato'
    end
  end
end
