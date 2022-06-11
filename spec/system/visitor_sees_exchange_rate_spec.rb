# frozen_string_literal: true

require 'rails_helper'

describe 'Visitor sees exchange rate list' do
  it 'successfully' do
    ExchangeRate.create!(rubi_coin: 1, brl_coin: 5, register_date: '01/07/2022', status: 'approved')
    ExchangeRate.create!(rubi_coin: 1, brl_coin: 5.12, register_date: '02/07/2022', status: 'approved')

    visit root_path
    click_on 'Taxa de câmbio'

    expect(page).to have_content 'Taxa de Câmbio RUBI/REAL'
    expect(page).to have_content '01/07/2022'
    expect(page).to have_content '02/07/2022'
    expect(page).to have_content '1 rubi equivale a R$ 5,00 reais'
    expect(page).to have_content '1 rubi equivale a R$ 5,12 reais'
    expect(page).not_to have_content 'Registrar taxa de câmbio'
  end

  it 'and theres no exchange rate registered' do
    visit root_path
    click_on 'Taxa de câmbio'

    expect(page).to have_content 'Nenhuma taxa de câmbio cadastrada'
    expect(page).not_to have_content 'Registrar taxa de câmbio'
  end

  it 'and is abble to back to home page' do
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Pagamentos'

    expect(page).to have_current_path root_path, ignore_query: true
  end
end
