# frozen_string_literal: true

require 'rails_helper'

describe 'POST /api/v1/client' do
  context 'with success' do
    it 'when client type is person' do
      attributes = {
        client: {
          client_type: 'client_person',
          client_person_attributes: {
            full_name: 'Zezinho',
            cpf: '12345678995'
          }
        }
      }

      post api_v1_clients_path, params: attributes
      expect(response).to have_http_status :created
      # debugger
      expect(Client.last.client_category.name).to eq 'Padrão'
      expect(JSON.parse(response.body)).to eq(
        { 'client_type' => 'client_person', 'client_person' => { 'full_name' => 'Zezinho', 'cpf' => '12345678995' } }
      )
    end

    it 'when client type is company' do
      attributes = {
        client: {
          client_type: 'client_company',
          client_company_attributes: {
            company_name: 'ACME LTDA',
            cnpj: '9494949498494'
          }
        }
      }

      post api_v1_clients_path, params: attributes

      expect(response).to have_http_status :created
      expect(Client.last.client_category.name).to eq 'Padrão'
      expect(JSON.parse(response.body)).to eq(
        {
          'client_type' => 'client_company', 'client_company' => {
            'company_name' => 'ACME LTDA', 'cnpj' => '9494949498494'
          }
        }
      )
    end
  end

  context 'when attributes is empty' do
    it 'when client type is empty' do
      attributes = {
        client: {
          client_person_attributes: {
            full_name: 'Zezinho',
            cpf: '12345678995'
          }
        }
      }

      post api_v1_clients_path, params: attributes

      json_response = JSON.parse(response.body).values.last
      expect(response).to have_http_status :unprocessable_entity
      expect(json_response).to eq 'A validação falhou: Tipo de cliente não pode ficar em branco'
    end

    it 'fail if there is an internal error' do
      allow(Client).to receive(:new).and_raise(ActiveRecord::ActiveRecordError.new('Erro interno'))

      attributes = {
        client_type: 'client_person',
        client: {
          client_person_attributes: {
            full_name: 'Zezinho',
            cpf: '12345678995'
          }
        }
      }

      post api_v1_clients_path, params: attributes

      json_response = JSON.parse(response.body).values.last
      expect(response).to have_http_status :internal_server_error
      expect(json_response).to eq 'Erro interno'
    end

    it 'fail if there is an bad request' do
      attributes = {}

      post api_v1_clients_path, params: attributes

      json_response = JSON.parse(response.body).values.last
      expect(response).to have_http_status :bad_request
      expect(json_response).to eq 'A validação falhou: sintaxe inválida'
    end
  end
end
