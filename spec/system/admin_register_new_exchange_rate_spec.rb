require 'rails_helper'

describe 'Admin register new exchange rate' do
  it 'successfully' do

    visit root_path
    click_on 'Taxa de câmbio rubi/real'
    click_on 'Registrar taxa de câmbio'

    fill_in 'Data de registro', with: '25/08/2022'
    fill_in 'Valor em reais', with: 5.10
    click_on 'Registrar taxa'

    expect(page).to have_content 'Taxas de câmbio RUBI/REAL'
    expect(page).to have_content '2022-08-25'
    expect(page).to have_content '1 rubi equivale a 5.1 reais'
    expect(current_path).to eq exchange_rates_path
  end

  it 'and doesnt fill all fields' do
    visit root_path
    click_on 'Taxa de câmbio rubi/real'
    click_on 'Registrar taxa de câmbio'

    fill_in 'Data de registro', with: ''
    click_on 'Registrar taxa'

    expect(page).to have_content 'Erro ao registrar taxa de câmbio'
    expect(page).to have_content 'Data de registro deve ser preenchida'
  end
end