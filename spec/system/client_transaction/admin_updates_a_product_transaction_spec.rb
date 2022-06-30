# frozen_string_literal: true

require 'rails_helper'

describe 'Admin change transaction status' do
  context 'when admin approve a transaction' do
    it 'when client is a client person' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)
      client = create(:client, client_type: 'client_person', balance: 8_000)
      create(:client_person, cpf: '93727923148', client: client)

      Timecop.freeze(1.week.ago) do
        client.client_bonus_balances.create!(bonus_value: 10_000, expire_date: Time.zone.today)
      end

      create(:client_bonus_balance, bonus_value: 15_000, client: client)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'transaction_order',
                                                       credit_value: 10_000)

      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'approved',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Aprovar', from: 'Status'
      click_on 'Salvar'

      expect(page).to have_content 'O status da transação foi atualizado com sucesso.'
      expect(ClientTransaction.last).to be_approved
      expect(client.reload.balance).to eq 8_000
      expect(client.client_bonus_balances.first.bonus_value).to eq 10_000
      expect(client.client_bonus_balances.last.bonus_value).to eq 5_000
    end

    it 'when client is a client company' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)
      client = create(:client, client_type: 'client_company', balance: 5_000)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:client_bonus_balance, bonus_value: 2_000, client: client)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'transaction_order',
                                                       credit_value: 5_000)

      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'approved',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Aprovar', from: 'Status'
      click_on 'Salvar'

      expect(page).to have_content 'O status da transação foi atualizado com sucesso.'
      expect(ClientTransaction.last).to be_approved
      expect(client.reload.balance).to eq 2_000
      expect(client.client_bonus_balances.last.bonus_value).to eq 0
    end

    it 'with insufficient funds' do
      client = create(:client, client_type: 'client_person', balance: 0)
      create(:client_person, cpf: '93727923148', client: client)
      create(:client_transaction, status: :pending, client: client,
                                  type_transaction: 'transaction_order', credit_value: 5_000)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Aprovar', from: 'Status'
      click_on 'Salvar'

      expect(page).to have_current_path client_transactions_path
      expect(page).to have_content 'Saldo insuficiente.'
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 0
    end

    it 'when the admin try to approve a inexistent transaction on ecommerce' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_code_not_found.json'))
      fake_response = instance_double('faraday_response', status: 404, body: json_data)
      client = create(:client, client_type: 'client_person', balance: 5_000)
      create(:client_person, cpf: '93727923148', client: client)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'transaction_order',
                                                       credit_value: 2_000)

      transaction_data = {
        transaction: {
          code: 'asjduhas0i7du8o12389782912312',
          status: 'approved',
          error_type: ''
        }
      }

      client_transaction.update!(code: 'asjduhas0i7du8o12389782912312')
      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Aprovar', from: 'Status'
      click_on 'Salvar'

      expect(page).to have_content 'Transação desconhecida pelo E-commerce.'
      expect(page).to have_current_path client_transactions_path
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 5_000
      expect(page).to have_content client_transaction.code
    end

    it 'and returns an internal error' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_internal_server_error.json'))
      fake_response = instance_double('faraday_response', status: 500, body: json_data)
      client = create(:client, client_type: 'client_person', balance: 5_000)
      create(:client_person, cpf: '93727923148', client: client)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'transaction_order',
                                                       credit_value: 2_000)

      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'approved',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Aprovar', from: 'Status'
      click_on 'Salvar'

      expect(page).to have_content 'Alguma coisa deu errado, por favor contate o suporte do E-commerce.'
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 5_000
    end
  end

  context 'when the admin refuse the transaction' do
    it 'with success' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)
      client = create(:client, client_type: 'client_company', balance: 51_000)
      create(:client_company, cnpj: '07638546899424', client: client)
      transaction = create(:client_transaction, status: :pending,
                                                client: client, type_transaction: 'transaction_order',
                                                credit_value: 51_000)

      transaction_data = {
        transaction: {
          code: transaction.code,
          status: 'refused',
          error_type: 'fraud_warning'
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Recusar', from: 'Status'
      fill_in 'Descrição', with: 'suspected fraud'
      click_on 'Salvar'

      expect(page).to have_content 'O status da transação foi atualizado com sucesso.'
      expect(ClientTransaction.last).to be_refused
      expect(client.reload.balance).to eq 51_000
      expect(TransactionNotification.last.description).to eq 'suspected fraud'
    end

    it 'when the admin try to refuse a inexistent transaction on ecommerce' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_code_not_found.json'))
      fake_response = instance_double('faraday_response', status: 404, body: json_data)
      client = create(:client, client_type: 'client_company', balance: 5_000)
      create(:client_company, cnpj: '07638546899424', client: client)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client, type_transaction: 'transaction_order',
                                                       credit_value: 2_000)

      transaction_data = {
        transaction: {
          code: 'asjduhas0i7du8o12389782912312',
          status: 'refused',
          error_type: 'fraud_warning'
        }
      }

      client_transaction.update!(code: 'asjduhas0i7du8o12389782912312')
      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Recusar', from: 'Status'
      fill_in 'Descrição', with: 'suspected fraud'
      click_on 'Salvar'

      expect(page).to have_content 'Transação desconhecida pelo E-commerce.'
      expect(page).to have_current_path client_transactions_path
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 5_000
      expect(TransactionNotification.all).to be_empty
    end

    it 'when error_type is empty' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_error_type_empty.json'))
      fake_response = instance_double('faraday_response', status: 422, body: json_data)
      client = create(:client, client_type: 'client_company', balance: 5_000)
      create(:client_company, cnpj: '07638546899424', client: client)
      transaction = create(:client_transaction, status: :pending,
                                                client: client, type_transaction: 'transaction_order',
                                                credit_value: 1_000)

      transaction_data = {
        transaction: {
          code: transaction.code,
          status: 'refused',
          error_type: 'fraud_warning'
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Recusar', from: 'Status'
      fill_in 'Descrição', with: 'Possível fraude'
      click_on 'Salvar'

      expect(page).to have_content 'Tipo de erro em branco.'
      expect(ClientTransaction.last.status).to eq 'pending'
      expect(client.reload.balance).to eq 5_000
      expect(TransactionNotification.all).to be_empty
    end

    it 'and returns an internal error' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_internal_server_error.json'))
      fake_response = instance_double('faraday_response', status: 500, body: json_data)
      client = create(:client, client_type: 'client_company', balance: 5_000)
      create(:client_company, cnpj: '07638546899424', client: client)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client, type_transaction: 'transaction_order',
                                                       credit_value: 1_000)

      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'refused',
          error_type: 'fraud_warning'
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Recusar', from: 'Status'
      fill_in 'Descrição', with: 'Possivel fraude'
      click_on 'Salvar'

      expect(page).to have_content 'Alguma coisa deu errado, por favor contate o suporte do E-commerce.'
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 5_000
      expect(TransactionNotification.all).to be_empty
    end
  end
end
