# frozen_string_literal: true

require 'rails_helper'

describe 'GET /api/v1/clients_info' do
  context 'when params is valid' do
    it 'with client person' do
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

    it 'with client company' do
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
  end

  context 'with fail' do
    it 'when params is empty' do
      get '/api/v1/clients_info'

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(json_response['message']).to include 'O numero de indentificação é inválido'
    end

    it 'when params is invalid' do
      get '/api/v1/clients_info', params: { registration_number: 'awdawdawd' }

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(json_response['message']).to include 'O numero de indentificação é inválido'
    end
  end
end
