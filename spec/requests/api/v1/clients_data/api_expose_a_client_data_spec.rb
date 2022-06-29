# frozen_string_literal: true

require 'rails_helper'

describe 'GET /api/v1/clients_info' do
  context 'when params is valid' do
    it 'with client person' do
      client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      client = Client.create!(client_type: 0, client_category_id: client_category.id, balance: 500)

      Timecop.freeze(1.week.ago) do
        client.client_bonus_balances.create!(bonus_value: 100, expire_date: Time.zone.today)
      end

      bonus_one = client.client_bonus_balances.create!(bonus_value: 100, expire_date: 2.weeks.from_now)
      bonus_two = client.client_bonus_balances.create!(bonus_value: 200, expire_date: 3.weeks.from_now)
      transaction = create(:client_transaction, client: client, status: 'approved', approval_date: Time.zone.now)
      client_person = ClientPerson.create!(full_name: 'Jossoandenson Kirton', cpf: '277.759.424-44',
                                           client_id: client.id)
      bonus_one_response = { 'bonus_value' => 100.0, 'expire_date' => bonus_one.expire_date.strftime('%Y-%m-%d') }
      bonus_two_response = { 'bonus_value' => 200.0, 'expire_date' => bonus_two.expire_date.strftime('%Y-%m-%d') }

      client_transaction = {
        credit_value: transaction.credit_value,
        type_transaction: transaction.type_transaction,
        transaction_date: transaction.transaction_date.strftime('%d/%m/%Y ás %H:%M'),
        status: transaction.status,
        approval_date: transaction.approval_date.strftime('%d/%m/%Y ás %H:%M'),
        code: transaction.code
      }.as_json

      get '/api/v1/clients_info', params: { registration_number: client_person.cpf }

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['client_info']['balance']).to eq 500
      expect(json_response['client_info']['bonus'].first).to eq(bonus_one_response)
      expect(json_response['client_info']['bonus'].last).to eq(bonus_two_response)
      expect(json_response['client_info']['name']).to eq 'Jossoandenson Kirton'
      expect(json_response['client_info']['transactions'].count).to eq 1
      expect(json_response['client_info']['transactions'].last).to include client_transaction
    end

    it 'with client company' do
      client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
      client = Client.create!(client_type: 0, client_category_id: client_category.id, balance: 0)

      Timecop.freeze(1.week.ago) do
        client.client_bonus_balances.create!(bonus_value: 100, expire_date: Time.zone.today)
      end

      client_company = ClientCompany.create!(company_name: 'ACME LTDA', cnpj: '07638546899424', client_id: client.id)

      get '/api/v1/clients_info', params: { registration_number: client_company.cnpj }

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['client_info']['balance']).to eq 0.0
      expect(json_response['client_info']['name']).to eq 'ACME LTDA'
      expect(json_response['client_info']['bonus']).to be_empty
      expect(json_response['client_info']['transactions']).to be_empty
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
