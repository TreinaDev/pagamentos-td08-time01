# frozen_string_literal: true

require 'rails_helper'

describe 'Admin change transaction status' do
  context 'when status is pending' do
    it 'and approve a transaction' do
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze, balance: 0)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Date.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      client_transaction = create(:client_transaction, status: :pending,
                                                       client: client, type_transaction: 'buy_rubys', credit_value: 51_000)

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
      )

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

    xit 'and refuse a transaction' do
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze, balance: 0)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Date.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
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
      )

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Recusar', from: 'Status'
      fill_in 'Descrição', with: 'Transação recusada por suspeita de fraude.'
      click_on 'Salvar'

      expect(page).to have_content 'A transação foi recusada com sucesso.'
      expect(ClientTransaction.last).to be_refused
      expect(client.reload.balance).to eq 0
      expect(ClientBonusBalance.last.nil?).to be true
      expect(TransactionNotification.last.description).to eq 'Transação recusada por suspeita de fraude.'
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
