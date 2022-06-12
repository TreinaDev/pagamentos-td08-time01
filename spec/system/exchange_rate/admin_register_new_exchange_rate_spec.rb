# frozen_string_literal: true

require 'rails_helper'

describe 'Admin register new exchange rate' do
  it 'successfully' do
    admin = create(:admin)

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Registrar taxa de câmbio'

    fill_in 'Data de registro', with: '25/08/2022'
    fill_in 'Valor em reais', with: 5.10
    click_on 'Registrar taxa'

    expect(page).to have_content 'Taxa de Câmbio RUBI/REAL'
    expect(page).to have_content '25/08/2022'
    expect(page).to have_content '1 rubi equivale a R$ 5,10 reais'
    expect(page).to have_current_path exchange_rates_path
    expect(ExchangeRate.last.created_by).to eq admin
  end

  it 'and variation is greater than 10%' do
    create(:exchange_rate, brl_coin: 5)
    admin = create(:admin)

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Registrar taxa de câmbio'

    fill_in 'Data de registro', with: '25/08/2022'
    fill_in 'Valor em reais', with: 6
    click_on 'Registrar taxa'

    expect(page).to have_content 'Taxa de câmbio em análise'
    expect(page).to have_current_path exchange_rates_path, ignore_query: true
  end

  it 'and doesnt fill all fields' do
    admin = create(:admin)

    login_as admin
    visit new_exchange_rate_path
    fill_in 'Data de registro', with: ''
    click_on 'Registrar taxa'

    expect(page).to have_content 'Erro ao registrar taxa de câmbio'
    expect(page).to have_content 'Data de registro não pode ficar em branco'
  end

  it 'and needs to be loged in' do
    visit new_exchange_rate_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
