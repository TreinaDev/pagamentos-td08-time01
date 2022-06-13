# frozen_string_literal: true

require 'rails_helper'

describe 'Pagamento API' do
  context 'when POST /api/v1/client_companies' do
    it 'success' do
      client_company_params = { client_company: { company_name: 'ACME LTDA', cnpj: '12345678998745' } }

      post '/api/v1/client_companies', params: client_company_params

      expect(response).to have_http_status :created
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['company_name']).to eq 'ACME LTDA'
      expect(json_response['cnpj']).to eq '12345678998745'
      expect(ClientCompany.count).to eq 1
      expect(ClientCompany.last.company_name).to eq 'ACME LTDA'
    end

    it 'if parameters are not complete' do
      client_company_params = { client_company: { full_name: '', cpf: '' } }

      post '/api/v1/client_companies', params: client_company_params

      expect(response).to have_http_status :precondition_failed
      expect(response.body).to include 'Razão social não pode ficar em branco'
      expect(response.body).to include 'CNPJ não pode ficar em branco'
      expect(ClientCompany.count).to eq 0
    end
  end
end
