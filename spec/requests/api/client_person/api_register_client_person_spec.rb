# frozen_string_literal: true

require 'rails_helper'

describe 'Pagamento API' do
  context 'when POST /api/v1/client_people' do
    it 'success' do
      client_person_params = { client_person: { full_name: 'Pedro Gomes', cpf: '12345678999' } }

      post '/api/v1/client_people', params: client_person_params

      expect(response).to have_http_status :created
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['full_name']).to eq 'Pedro Gomes'
      expect(json_response['cpf']).to eq '12345678999'
    end

    it 'if parameters are not complete' do
      client_person_params = { client_person: { full_name: '', cpf: '' } }

      post '/api/v1/client_people', params: client_person_params

      expect(response).to have_http_status :precondition_failed
      expect(response.body).to include 'Nome completo não pode ficar em branco'
      expect(response.body).to include 'CPF não pode ficar em branco'
    end
  end
end