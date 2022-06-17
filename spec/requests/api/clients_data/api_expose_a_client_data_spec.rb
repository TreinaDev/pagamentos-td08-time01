# frozen_string_literal: true

require 'rails_helper'

describe 'Pagamento API' do
  context 'when POST /api/v1/clients' do
    it 'success as client person' do
      client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      client = Client.create!(client_type: 0, client_category_id: client_category.id, balance: 0)
      client_person = ClientPerson.create!(full_name: 'Jossoandenson Kirton', cpf: '277.759.424-44',
                                           client_id: client.id)

      post '/api/v1/clients', params: { registration_number: client_person.cpf }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response[0]['balance']).to eq 0.0
      expect(json_response[1]['name']).to eq 'Bronze'
      expect(json_response[1]['discount_percent']).to eq 0
      expect(json_response[2]['full_name']).to eq 'Jossoandenson Kirton'
      expect(json_response[2]['cpf']).to eq '277.759.424-44'
      expect(json_response[0].count).to eq 1
      expect(json_response[1].count).to eq 2
      expect(json_response[2].count).to eq 2
    end

    it 'success as client company' do
      client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      client = Client.create!(client_type: 0, client_category_id: client_category.id, balance: 0)
      client_company = ClientCompany.create!(company_name: 'ACME LTDA', cnpj: '71721257678217', client_id: client.id)

      post '/api/v1/clients', params: { registration_number: client_company.cnpj }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response[0]['balance']).to eq 0.0
      expect(json_response[1]['name']).to eq 'Bronze'
      expect(json_response[1]['discount_percent']).to eq 0
      expect(json_response[2]['company_name']).to eq 'ACME LTDA'
      expect(json_response[2]['cnpj']).to eq '71721257678217'
      expect(json_response[0].count).to eq 1
      expect(json_response[1].count).to eq 2
      expect(json_response[2].count).to eq 2
    end

    it 'fail' do
      post '/api/v1/clients'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['errors']).to include 'Cliente não encontrado'
    end
  end
end
