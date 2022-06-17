# frozen_string_literal: true

require 'rails_helper'

describe 'Register a new client_person' do
  context 'when POST /api/v1/client_people creates' do
    it 'success' do
      ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      Client.create!(client_type: 0, client_category_id: 1)
      client_person_params = { client_person: { full_name: 'Pedro Gomes', cpf: '53533989550', client_id: 1 } }

      post '/api/v1/client_people', params: client_person_params

      expect(response).to have_http_status :created
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['full_name']).to eq 'Pedro Gomes'
      expect(json_response['cpf']).to eq '535.339.895-50'
      expect(ClientPerson.count).to eq 1
      expect(ClientPerson.last.full_name).to eq 'Pedro Gomes'
    end

    it 'if parameters are not complete' do
      ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      Client.create!(client_type: 0, client_category_id: 1)
      client_person_params = { client_person: { full_name: '', cpf: '', client_id: 1 } }

      post '/api/v1/client_people', params: client_person_params

      expect(response).to have_http_status :precondition_failed
      expect(response.body).to include 'Nome completo não pode ficar em branco'
      expect(response.body).to include 'CPF não pode ficar em branco'
      expect(ClientPerson.count).to eq 0
    end
  end
end
