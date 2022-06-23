# frozen_string_literal: true

require 'rails_helper'

describe 'POST /api/v1/client_transaction' do
  context 'when transaction is valid' do
    it 'with client person buying rubys' do
      create(:transaction_setting, max_credit: 50_000)
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
      expect(ClientTransaction.last.status).to eq 'active'
      expect(Client.last.balance).to eq 10_000
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to be_empty
    end

    it 'with client company is buying rubys' do
      create(:transaction_setting, max_credit: 50_000)
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
      expect(ClientTransaction.last.status).to eq 'active'
      expect(Client.last.balance).to eq 10_000
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to be_empty
    end

    it 'when client company transaction overpass the credit limit' do
      create(:transaction_setting, max_credit: 10_000)
      client = create(:client, client_type: 5, balance: 5000)
      create(:client_company, cnpj: '07638546899424', client: client)

      attributes = {
        cnpj: '07638546899424',
        client_transaction: {
          credit_value: 11_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :created
      expect(ClientTransaction.last.status).to eq 'pending'
      expect(Client.last.balance).to eq 5_000
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to be_empty
    end

    it 'when client person transaction overpass the credit limit' do
      create(:transaction_setting, max_credit: 10_000)
      client = create(:client, client_type: 0, balance: 5000)
      create(:client_person, cpf: '06001818398', client: client)

      attributes = {
        cpf: '06001818398',
        client_transaction: {
          credit_value: 11_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :created
      expect(ClientTransaction.last.status).to eq 'pending'
      expect(Client.last.balance).to eq 5_000
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to be_empty
    end
  end

  context 'when transaction attributes is invalid' do
    it 'when client person registration number is invalid' do
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
      expect(ClientTransaction.count).to eq 0
      expect(JSON.parse(response.body)['message']).to eq(
        'Não foi possível encontrar Pessoa física com os dados informados'
      )
      expect(ClientTransaction.count).to eq 0
    end

    it 'when client company registration number is invalid' do
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
      expect(ClientTransaction.count).to eq 0
      expect(JSON.parse(response.body)['message']).to eq(
        'Não foi possível encontrar Pessoa jurídica com os dados informados'
      )
      expect(ClientTransaction.count).to eq 0
    end

    it 'when credit value is invalid' do
      create(:transaction_setting, max_credit: 50_000)
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
      expect(ClientTransaction.count).to eq 0
      expect(JSON.parse(response.body)['message']).to eq 'A validação falhou: Valor não é um número'
    end
  end

  context 'when transaction attributes is empty' do
    it 'when credit value is empty' do
      create(:transaction_setting, max_credit: 50_000)
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
      expect(ClientTransaction.count).to eq 0
      expect(JSON.parse(response.body)['message']).to eq(
        'A validação falhou: Valor não pode ficar em branco, Valor não é um número'
      )
    end

    it 'when client person registration number is empty' do
      create(:client_person, cpf: '06001818398')

      attributes = {
        cpf: '',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :bad_request
      expect(JSON.parse(response.body)['message']).to eq('A validação falhou: sintaxe inválida')
      expect(ClientTransaction.count).to eq 0
    end

    it 'when client company registration number is empty' do
      create(:client_company, cnpj: '07638546899424')

      attributes = {
        cnpj: '',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :bad_request
      expect(JSON.parse(response.body)['message']).to eq('A validação falhou: sintaxe inválida')
      expect(ClientTransaction.count).to eq 0
    end
  end

  context 'when transaction attributes are missing' do
    it 'when all atributes are missing' do
      attributes = {}

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :bad_request
      expect(ClientTransaction.count).to eq 0
    end

    it 'when registration number is missing' do
      create(:client_company, cnpj: '07638546899424')

      attributes = {
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :bad_request
    end

    it 'when client transaction parameters are missing' do
      create(:client_company, cnpj: '07638546899424')

      attributes = {
        cnpj: '07638546899424'
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :bad_request
      expect(ClientTransaction.count).to eq 0
    end
  end
end
