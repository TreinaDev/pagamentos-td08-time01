# frozen_string_literal: true

require 'rails_helper'

describe 'Register a new client' do
  context 'when POST /api/v1/client' do
    it 'with success when client category is person' do
      create(:client_category, name: 'Ouro', discount_percent: 0)
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
      expect(Client.last.client_category.name).to eq 'Padrão'
    end

    it 'with success when client category is company' do
      create(:client_category, discount_percent: 0)
      attributes = {
        client: {
          client_type: 'client_person',
          client_company_attributes: {
            company_name: 'ACME LTDA',
            cnpj: '9494949498494'
          }
        }
      }

      post api_v1_clients_path, params: attributes

      expect(response).to have_http_status :created
    end
  end
end
