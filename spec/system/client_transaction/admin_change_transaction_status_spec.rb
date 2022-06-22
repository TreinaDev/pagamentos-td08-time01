# frozen_string_literal: true

require 'rails_helper'

describe 'Admin change transaction status' do
  context 'when status is pending' do
    it 'and approve a transaction' do
      client = create(:client_person).client
      create(:client_transaction, status: :pending, client:)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Aprovar', from: 'Status'
      click_on 'Salvar'

      expect(page).to have_content 'A transação foi alterada com sucesso.'
      expect(ClientTransaction.last.active?).to be true
    end

    it 'and refuse a transaction' do
      client = create(:client_person).client
      create(:client_transaction, status: :pending, client:)

      login_as create(:admin, status: :active)
      visit root_path
      click_on 'Transações'
      click_on 'Aprovar/Recusar'
      select 'Recusar', from: 'Status'
      click_on 'Salvar'

      expect(page).to have_content 'A transação foi alterada com sucesso.'
      expect(ClientTransaction.last.refused?).to be true
    end
  end

  context 'when status is not pending' do
    it 'redirect when status is active' do
      client = create(:client_person).client
      create(:client_transaction, status: :active, client:)

      login_as create(:admin, status: :active)
      visit edit_client_transaction_path(ClientTransaction.last.id)

      expect(page).to have_content 'A transação não pode ser alterada.'
    end

    it 'redirect when status is refused' do
      client = create(:client_person).client
      create(:client_transaction, status: :refused, client:)

      login_as create(:admin, status: :active)
      visit edit_client_transaction_path(ClientTransaction.last.id)

      expect(page).to have_content 'A transação não pode ser alterada.'
    end
  end
end
