# frozen_string_literal: true

require 'rails_helper'

describe 'POST /api/v1/client_transaction' do
  context 'when transaction is valid' do
    it 'with client_person' do
      create(:client_person, cpf: '06001818398')

      attributes = {
        cpf: '06001818398',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :created
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to include('status' => 'pending')
    end

    it 'with client_company' do
      create(:client_company, cnpj: '07638546899424')

      attributes = {
        cnpj: '07638546899424',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :created
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to include('status' => 'pending')
    end
  end

  context 'when transaction attributes is invalid' do
    it 'when client_person registration number is invalid' do
      create(:client_person, cpf: '06001818398')

      attributes = {
        cpf: '00000000000000',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :not_found
      expect(JSON.parse(response.body)['message']).to eq(
        'Não foi possível encontrar Pessoa física com os dados informados'
      )
      expect(ClientTransaction.count).to eq 0
    end

    it 'when client_company registration number is invalid' do
      create(:client_company, cnpj: '07638546899424')

      attributes = {
        cnpj: '00000000000000',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :not_found
      expect(JSON.parse(response.body)['message']).to eq(
        'Não foi possível encontrar Pessoa jurídica com os dados informados'
      )
      expect(ClientTransaction.count).to eq 0
    end

    it 'when credit_value is invalid' do
      create(:client_company, cnpj: '07638546899424')

      attributes = {
        cnpj: '07638546899424',
        client_transaction: {
          credit_value: 'fjmspeof',
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['message']).to eq 'A validação falhou: Valor não é um número'
    end
  end

  context 'when transaction attributes is empty' do
    it 'when credit_value is empty' do
      create(:client_company, cnpj: '07638546899424')

      attributes = {
        cnpj: '07638546899424',
        client_transaction: {
          credit_value: '',
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['message']).to eq(
        'A validação falhou: Valor não pode ficar em branco, Valor não é um número'
      )
    end
  end
end
