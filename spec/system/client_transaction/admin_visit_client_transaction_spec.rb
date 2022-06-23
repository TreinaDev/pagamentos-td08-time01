# frozen_string_literal: true

require 'rails_helper'

describe 'Admin visit client_transactions' do
  context 'when exist client_transactions register' do
    it 'when only exist client_transactions pending' do
      client = create(:client_person).client
      create(:client_transaction, credit_value: 10_000, status: :pending, client: client)
      create(:client_transaction, credit_value: 5_000, status: :pending, client: client)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'

      expect(page).to have_current_path client_transactions_path
      expect(page).to have_content '10000.0'
      expect(page).to have_content '5000.0'
      expect(page).to have_content 'Compra de rubis'
    end

    it 'when only exist client_transactions refused' do
      client = create(:client_person).client
      create(:client_transaction, status: :refused, client: client)
      create(:client_transaction, status: :refused, client: client)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'

      expect(page).to have_current_path client_transactions_path
      expect(page).to have_content 'Não há transações pendentes'
    end

    it 'when only exist client_transactions active' do
      client = create(:client_person).client
      create(:client_transaction, status: :active, client: client)
      create(:client_transaction, status: :active, client: client)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'

      expect(page).to have_current_path client_transactions_path
      expect(page).to have_content 'Não há transações pendentes'
    end
  end
end
