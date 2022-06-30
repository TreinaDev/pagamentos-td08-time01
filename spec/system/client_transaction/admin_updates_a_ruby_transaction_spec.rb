# frozen_string_literal: true

require 'rails_helper'

describe 'Admin change transaction status' do
  context 'when admin approve a transaction' do
    before { Timecop.freeze(Time.zone.today.beginning_of_day) }

    after { Timecop.return }

    it 'when client is a client person' do
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_person', client_category: bronze, balance: 0)
      create(:client_person, cpf: '93727923148', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      create(:client_transaction, status: :pending, client: client,
                                  type_transaction: 'buy_rubys', credit_value: 51_000)

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
      create(:transaction_setting, max_credit: 50_000)
      bronze = create(:client_category, name: 'Bronze')
      client = create(:client, client_type: 'client_company', client_category: bronze, balance: 0)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:promotion, start_date: Time.zone.today,
                         end_date: Time.zone.tomorrow, bonus: 10, limit_day: 30, client_category: bronze)
      create(:client_transaction, status: :pending, client: client,
                                  type_transaction: 'buy_rubys', credit_value: 51_000)

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
  end

  context 'when the admin declines the transaction' do
    it 'with success' do
      create(:transaction_setting, max_credit: 50_000)
      client = create(:client, client_type: 'client_company', balance: 51_000)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:client_transaction, status: :pending,
                                  client: client, type_transaction: 'buy_rubys', credit_value: 51_000)

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
      expect(TransactionNotification.last.description).to eq 'suspected fraud'
    end

    it 'with description is empty' do
      create(:transaction_setting, max_credit: 50_000)
      client = create(:client, client_type: 'client_company', balance: 0)
      create(:client_company, cnpj: '07638546899424', client: client)
      create(:client_transaction, status: :pending, client: client,
                                  type_transaction: 'buy_rubys', credit_value: 51_000)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Recusar', from: 'Status'
      fill_in 'Descrição', with: ''
      click_on 'Salvar'

      expect(page).to have_content 'Descrição não pode ficar em branco.'
      expect(ClientTransaction.last).to be_pending
      expect(client.reload.balance).to eq 0
      expect(TransactionNotification.count).to be_zero
    end
  end
end
