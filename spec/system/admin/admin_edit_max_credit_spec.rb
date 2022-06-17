# frozen_string_literal: true

require 'rails_helper'

describe 'admin edit a max credit' do
  it 'with success' do
    create(:transaction_setting)

    login_as create(:admin, status: 5)
    visit root_path
    click_on 'Configurações'
    fill_in 'Crédito máximo', with: '20000'
    click_on 'Cadastrar'
    transaction_setting = TransactionSetting.last

    expect(page).to have_current_path edit_transaction_setting_path(transaction_setting)
    expect(page).to have_field 'Crédito máximo', with: '20000.0'
    expect(page).to have_content 'A configuração foi atualizada com sucesso.'
  end

  it 'when max credit is less than 0' do
    create(:transaction_setting)

    login_as create(:admin, status: 5)
    visit root_path
    click_on 'Configurações'
    fill_in 'Crédito máximo', with: '-10'
    click_on 'Cadastrar'
    transaction_setting = TransactionSetting.last

    expect(page).to have_current_path transaction_setting_path(transaction_setting)
    expect(page).to have_field 'Crédito máximo', with: '-10'
    expect(page).to have_content 'Não foi possível atualizar a configuração.'
  end
end
