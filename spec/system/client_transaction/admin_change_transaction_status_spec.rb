# frozen_string_literal: true

require 'rails_helper'

describe 'Admin change transaction status' do
  context 'when admin approve a transaction' do
    before do
      Timecop.freeze(Time.zone.today)
      Timecop.freeze(Time.zone.tomorrow)
    end

    it 'when client is a client person' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_person', client_category: bronze, balance: 0)
      create(:client_person, cpf: '93727923148', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'buy_rubys',
                                                       credit_value: 51_000)

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

      expect(page).to have_content 'A transação foi realizada com sucesso.'
      expect(ClientTransaction.last).to be_approved
      expect(client.reload.balance).to eq 51_000
      expect(client.client_bonus_balances.last.bonus_value).to eq 5_100
      expect(client.client_bonus_balances.last.expire_date).to eq Time.zone.today + Promotion.last.limit_day.days
    end

    it 'when client is a client company' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze, balance: 0)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'buy_rubys',
                                                       credit_value: 51_000)

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

      expect(page).to have_content 'A transação foi realizada com sucesso.'
      expect(ClientTransaction.last).to be_approved
      expect(client.reload.balance).to eq 51_000
      expect(client.client_bonus_balances.last.bonus_value).to eq 5_100
      expect(client.client_bonus_balances.last.expire_date).to eq Time.zone.today + Promotion.last.limit_day.days
    end

    it 'when the admin try to approve a inexistent transaction on ecommerce' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_code_not_found.json'))
      fake_response = instance_double('faraday_response', status: 404, body: json_data)
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_person', client_category: bronze, balance: 0)
      create(:client_person, cpf: '93727923148', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'buy_rubys',
                                                       credit_value: 51_000)

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

      expect(page).to have_content 'Transação desconhecida pelo ecommerce'
      expect(page).to have_current_path client_transactions_path
      expect(ClientTransaction.last).to be_pending
      expect(page).to have_content client_transaction.code
    end

    it 'and returns an internal error' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_internal_server_error.json'))
      fake_response = instance_double('faraday_response', status: 500, body: json_data)
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_person', client_category: bronze, balance: 0)
      create(:client_person, cpf: '93727923148', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'buy_rubys',
                                                       credit_value: 51_000)

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

      expect(page).to have_content 'Alguma coisa deu errado, por favor contate o suporte do ecommerce'
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 0.0
    end
  end

  context 'when the admin declines the transaction' do
    it 'with success' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze, balance: 51_000)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      transaction = create(:client_transaction, status: :pending,
                                                client: client, type_transaction: 'buy_rubys', credit_value: 51_000)

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

      expect(page).to have_content 'A transação foi recusada com sucesso.'
      expect(ClientTransaction.last).to be_refused
      expect(client.reload.balance).to eq 51_000
      expect(ClientBonusBalance.last.nil?).to be true
      expect(TransactionNotification.last.description).to eq 'suspected fraud'
    end

    it 'when the admin try to refuse a inexistent transaction on ecommerce' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_code_not_found.json'))
      fake_response = instance_double('faraday_response', status: 404, body: json_data)
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze, balance: 0)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'buy_rubys',
                                                       credit_value: 51_000)

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

      expect(page).to have_content 'Transação desconhecida pelo ecommerce'
      expect(page).to have_current_path client_transactions_path
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 0.0
      expect(TransactionNotification.all).to be_empty
    end

    it 'when error_type is empty' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_error_type_empty.json'))
      fake_response = instance_double('faraday_response', status: 422, body: json_data)
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze, balance: 0)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      transaction = create(:client_transaction, status: :pending,
                                                client: client, type_transaction: 'buy_rubys', credit_value: 51_000)

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
      fill_in 'Descrição', with: 'Possivel fraude'
      click_on 'Salvar'

      expect(page).to have_content 'Tipo de erro em branco'
      expect(ClientTransaction.last.status).to eq 'pending'
      expect(client.reload.balance).to eq 0.0
      expect(TransactionNotification.all).to be_empty
    end

    it 'and returns an internal error' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_internal_server_error.json'))
      fake_response = instance_double('faraday_response', status: 500, body: json_data)
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze, balance: 0)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client,
                                                       type_transaction: 'buy_rubys',
                                                       credit_value: 51_000)

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

      expect(page).to have_content 'Alguma coisa deu errado, por favor contate o suporte do ecommerce'
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 0.0
      expect(TransactionNotification.all).to be_empty
    end
  end

  context 'when status is not pending' do
    it 'redirect when status is active' do
      client = create(:client_person).client
      create(:client_transaction, status: :approved, client: client)

      login_as create(:admin, status: :active)
      visit edit_client_transaction_path(ClientTransaction.last.id)

      expect(page).to have_content 'A transação não pode ser alterada.'
    end

    it 'redirect when status is refused' do
      client = create(:client_person).client
      create(:client_transaction, status: :refused, client: client)

      login_as create(:admin, status: :active)
      visit edit_client_transaction_path(ClientTransaction.last.id)

      expect(page).to have_content 'A transação não pode ser alterada.'
    end
  end
end
