# frozen_string_literal: true

require 'rails_helper'

describe 'admin recuse exchange rate' do
  it 'successfully' do
    admin = create(:admin)

    ExchangeRate.create!(brl_coin: 5, created_by: admin, register_date: 1.week.from_now)
    er = ExchangeRate.create!(brl_coin: 6, created_by: admin, register_date: 2.weeks.from_now, status: 'pending')

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on I18n.l(2.weeks.from_now.to_date)
    click_on 'Recusar taxa'

    expect(page).to have_content I18n.l(2.weeks.from_now.to_date)
    expect(page).to have_content 'Status: Recusada'
    expect(page).not_to have_button 'Aprovar taxa'
    expect(page).to have_content 'Taxa recusada com sucesso'
    expect(page).to have_current_path exchange_rate_path(er)
    expect(ExchangeRate.last.status).to eq 'recused'
    expect(page).to have_content "Recusada por: #{admin.full_name}"
  end
end
