# frozen_string_literal: true

require 'rails_helper'

describe 'admin approve exchange rate' do
  it 'successfully' do
    admin = create(:admin)
    admin2 = create(:admin, email: 'b2@userubis.com.br', cpf: '57079167094')
    create(:exchange_rate, brl_coin: 5, created_by: admin, register_date: 2.days.from_now)
    er = create(:exchange_rate, brl_coin: 6, created_by: admin, register_date: 3.days.from_now)

    login_as admin2
    post(approved_exchange_rate_path(er),
         params: { 'controller' => 'exchange_rates', 'action' => 'approved', 'id' => '2' })

    expect(response).to redirect_to exchange_rate_path(er)
    expect(assert_response(:redirect)).to be true
    expect(ExchangeRate.last.status).to eq 'approved'
  end

  it 'and isnt logged in' do
    admin = create(:admin)
    er = create(:exchange_rate, created_by: admin)

    post(approved_exchange_rate_path(er))

    expect(response).to redirect_to new_admin_session_path
  end
end
