# frozen_string_literal: true

require 'rails_helper'

describe 'Admin sees details from a' do
  it 'approved exchange rate successfully' do
    admin = create(:admin)
    admin2 = create(:admin, email: 'b@userubis.com.br')
    create(:exchange_rate, created_by: admin)
    er = create(:exchange_rate, register_date: 1.day.from_now, created_by: admin, approved_by: admin2,
                                status: 'approved', brl_coin: 5.05)

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on I18n.l(1.day.from_now.to_date)

    expect(page).to have_content "Taxa de Câmbio #{I18n.l(1.day.from_now.to_date)}"
    expect(page).to have_content 'Status: Aprovada'
    expect(page).to have_content "Registrada por #{admin.full_name}"
    expect(page).to have_content "Aprovada por #{admin2.full_name}"
    expect(page).to have_content 'Valor: R$ 5,05 reais'
    expect(page).to have_content 'Variação em relação a última taxa aprovada: 1.0%'
  end

  it 'pending of approvement exchange rate successfully' do
    admin = create(:admin)
    create(:exchange_rate, created_by: admin)
    er = create(:exchange_rate, register_date: 1.day.from_now, created_by: admin, brl_coin: 6, status: 'pending')

    login_as admin
    visit exchange_rate_path(er)

    expect(page).to have_content "Taxa de Câmbio #{I18n.l(1.day.from_now.to_date)}"
    expect(page).to have_content 'Status: Pendente'
    expect(page).to have_content "Registrada por #{admin.full_name}"
  end

  it 'and needs to be loged in' do
    admin = create(:admin)
    er = create(:exchange_rate, created_by: admin)

    visit exchange_rate_path(er)

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
