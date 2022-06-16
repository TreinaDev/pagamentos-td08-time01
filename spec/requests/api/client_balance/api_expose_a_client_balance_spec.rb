# frozen_string_literal: true

require 'rails_helper'

describe 'Pagamento API' do
  context 'when GET /api/v1/clients/1' do
    it 'success' do
      client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      client = Client.create!(client_type: 0, client_category_id: client_category.id, balance: 0)
      ClientPerson.create!(full_name: 'Jossoandenson Kirton', cpf: '277.759.424-44', client_id: client.id)

      get "/api/v1/clients/#{client.id}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['balance']).to eq 0.0
    end

    it 'fail' do
      get '/api/v1/clients/2'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['errors']).to include 'Cliente não encontrado'
    end
  end
end
