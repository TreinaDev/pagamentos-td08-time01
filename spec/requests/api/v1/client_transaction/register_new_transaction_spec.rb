# frozen_string_literal: true

require 'rails_helper'

describe 'POST /api/v1/client_transaction' do
  let(:admin) { create(:admin, status: :active) }
  let(:admin_two) { create(:admin, status: :active) }
  let(:create_exchange_rate) do
    create(:exchange_rate, brl_coin: 10, rubi_coin: 1, status: 'approved', created_by_id: admin.id,
                           approved_by_id: admin_two.id, register_date: Time.zone.today)
  end

  before { create_exchange_rate }

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
      expect(ClientTransaction.last.status).to eq 'approved'
      expect(Client.last.balance).to eq 10_000
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to eq('code' => ClientTransaction.last.code)
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
      expect(ClientTransaction.last.status).to eq 'approved'
      expect(Client.last.balance).to eq 10_000
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to eq('code' => ClientTransaction.last.code)
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

  context 'when client category has a promotion' do
    it 'when client person buying rubys' do
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_person', client_category: bronze)
      create(:client_person, cpf: '06001818398', client: client)
      create(:promotion, start_date: Time.current,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)

      attributes = {
        cpf: '06001818398',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :created
      expect(ClientTransaction.last.status).to eq 'approved'
      expect(Client.last.balance).to eq 10_000
      expect(Client.last.client_bonus_balances.last.bonus_value).to eq 1_000
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to eq('code' => ClientTransaction.last.code)
    end

    it 'when client company is buying rubys' do
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Date.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)

      attributes = {
        cnpj: '07638546899424',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'buy_rubys'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :created
      expect(ClientTransaction.last.status).to eq 'approved'
      expect(Client.last.balance).to eq 10_000
      expect(Client.last.client_bonus_balances.last.bonus_value).to eq 1_000
      expect(ClientTransaction.all.count).to eq 1
      expect(JSON.parse(response.body)).to eq('code' => ClientTransaction.last.code)
    end
  end

  context 'when transaction overpass the credit limit' do
    it 'with client company' do
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
      expect(JSON.parse(response.body)).to eq('code' => ClientTransaction.last.code)
    end

    it 'with client person' do
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
      expect(JSON.parse(response.body)).to eq('code' => ClientTransaction.last.code)
    end
  end
end
