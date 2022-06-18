# frozen_string_literal: true

require 'rails_helper'

describe 'admin register a new max credit' do
  it 'with success' do
    login_as create(:admin, status: 5)
    visit root_path
    click_on 'Configurações'
    fill_in 'Crédito máximo', with: '30000'
    click_on 'Cadastrar'
    transaction_setting = TransactionSetting.last

    expect(page).to have_current_path edit_transaction_setting_path(transaction_setting)
    expect(page).to have_field 'Crédito máximo', with: '30000.0'
    expect(page).to have_content 'A configuração foi cadastrada com sucesso.'
  end

  it 'when max credit is less than 0' do
    login_as create(:admin, status: 5)
    visit root_path
    click_on 'Configurações'
    fill_in 'Crédito máximo', with: '0'
    click_on 'Cadastrar'

    expect(page).to have_current_path transaction_settings_path
    expect(page).to have_field 'Crédito máximo', with: '0'
    expect(page).to have_content 'Não foi possível cadastrar a configuração.'
  end
end
