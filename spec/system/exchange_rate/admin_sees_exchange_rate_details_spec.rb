# frozen_string_literal: true

require 'rails_helper'

describe 'Admin sees details from a' do
  it 'approved exchange rate successfully' do
    admin = create(:admin)
    admin2 = create(:admin, email: 'b@userubis.com.br')
    create(:exchange_rate, created_by: admin, brl_coin: 5)
    create(:exchange_rate, register_date: 1.day.from_now, created_by: admin, approved_by: admin2,
                           status: 'approved', brl_coin: 6)

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on I18n.l(1.day.from_now.to_date)

    expect(page).to have_content I18n.l(1.day.from_now.to_date)
    expect(page).to have_content 'Status: Aprovada'
    expect(page).to have_content "Registrada por: #{admin.full_name}"
    expect(page).to have_content "Aprovada por: #{admin2.full_name}"
    expect(page).to have_content 'Valor: R$ 6,00'
    expect(page).to have_content 'Variação em relação a última taxa aprovada: 20.0%'
    expect(ExchangeRate.last.status).to eq 'approved'
  end

  it 'pending of approvement exchange rate successfully' do
    admin = create(:admin)
    create(:exchange_rate, created_by: admin, brl_coin: 2)
    rate = create(:exchange_rate, register_date: 1.day.from_now, created_by: admin, brl_coin: 4, status: 'pending')

    login_as admin
    visit exchange_rate_path(rate)

    expect(page).to have_content I18n.l(1.day.from_now.to_date)
    expect(page).to have_content 'Status: Pendente'
    expect(page).to have_content "Registrada por: #{admin.full_name}"
  end

  it 'and needs to be logged in' do
    admin = create(:admin)
    rate = create(:exchange_rate, created_by: admin)

    visit exchange_rate_path(rate)

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
