# frozen_string_literal: true

require 'rails_helper'

describe 'Admin approve exchange rate' do
  it 'successfully' do
    admin = create(:admin)
    admin2 = create(:admin, email: 'b@userubis.com.br')

    ExchangeRate.create!(brl_coin: 5, created_by: admin, register_date: 1.week.from_now)
    er = ExchangeRate.create!(brl_coin: 6, created_by: admin, register_date: 2.weeks.from_now, status: 'pending')

    login_as admin2
    visit root_path
    click_on 'Taxa de câmbio'
    click_on I18n.l(2.weeks.from_now.to_date)
    click_on 'Aprovar taxa'

    expect(page).to have_content I18n.l(2.weeks.from_now.to_date)
    expect(page).to have_content 'Status: Aprovada'
    expect(page).not_to have_button 'Aprovar taxa'
    expect(page).to have_content 'Taxa aprovada com sucesso'
    expect(page).to have_current_path exchange_rate_path(er), ignore_query: true
  end

  it 'and try to approve his own register of a exchange rate' do
    admin = create(:admin)
    create(:exchange_rate, created_by: admin, brl_coin: 5)
    er = create(:exchange_rate, created_by: admin, brl_coin: 6, register_date: 1.week.from_now, status: 'pending')

    login_as admin
    visit exchange_rate_path(er)
    click_on 'Aprovar taxa'

    expect(page).to have_content 'Taxa não pode ser aprovada pelo mesmo administrador que registrou'
    expect(er.status).to eq 'pending'
  end

  it 'and needs to be loged in' do
  end
end
