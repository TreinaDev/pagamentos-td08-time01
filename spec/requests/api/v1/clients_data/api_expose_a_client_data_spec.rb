# frozen_string_literal: true

require 'rails_helper'

describe 'Pagamento API' do
  context 'when GET /api/v1/clients_info' do
    it 'success as client person' do
      client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      client = Client.create!(client_type: 0, client_category_id: client_category.id, balance: 0)
      client_person = ClientPerson.create!(full_name: 'Jossoandenson Kirton', cpf: '277.759.424-44',
                                           client_id: client.id)

      get '/api/v1/clients_info', params: { registration_number: client_person.cpf }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['client_balance']['balance']).to eq 0.0
      expect(json_response['client_info']['full_name']).to eq 'Jossoandenson Kirton'
      expect(json_response['client_info']['cpf']).to eq '277.759.424-44'
      expect(json_response['client_balance'].count).to eq 1
      expect(json_response['client_info'].count).to eq 2
    end

    it 'success as client company' do
      client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      client = Client.create!(client_type: 0, client_category_id: client_category.id, balance: 0)
      client_company = ClientCompany.create!(company_name: 'ACME LTDA', cnpj: '07638546899424', client_id: client.id)

      get '/api/v1/clients_info', params: { registration_number: client_company.cnpj }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['client_balance']['balance']).to eq 0.0
      expect(json_response['client_info']['company_name']).to eq 'ACME LTDA'
      expect(json_response['client_info']['cnpj']).to eq '07.638.546/8994-24'
      expect(json_response['client_balance'].count).to eq 1
      expect(json_response['client_info'].count).to eq 2
    end

    it 'fail' do
      get '/api/v1/clients_info'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['errors']).to include 'Cliente não encontrado'
    end
  end
end
