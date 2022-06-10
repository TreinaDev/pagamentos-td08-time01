require 'rails_helper'

describe 'Admin sees exchange rate list' do
  it 'successfully' do
    ExchangeRate.create!(rubi_coin: 1, brl_coin: 5, register_date: '01/07/2022', status: 'approved')
    ExchangeRate.create!(rubi_coin: 1, brl_coin: 5.12, register_date: '02/07/2022', status: 'approved')

    visit root_path
    click_on 'Taxa de câmbio rubi/real'

    expect(page).to have_content 'Taxas de câmbio RUBI/REAL'
    expect(page).to have_content "2022-07-01"
    expect(page).to have_content "2022-07-02"
    expect(page).to have_content '1 rubi equivale a 5.0 reais'
    expect(page).to have_content '1 rubi equivale a 5.12 reais'
  end

  it 'and theres no exchange rate registered' do
    visit root_path
    click_on 'Taxa de câmbio rubi/real'

    expect(page).to have_content 'Nenhuma taxa de câmbio cadastrada'
  end

  it 'and is abble to back to home page' do

    visit root_path
    click_on 'Taxa de câmbio rubi/real'
    click_on 'Pagamentos'

    expect(current_path).to eq root_path
  end
end