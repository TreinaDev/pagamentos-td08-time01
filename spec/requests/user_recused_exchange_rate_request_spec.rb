# frozen_string_literal: true

require 'rails_helper'

describe 'user recuse exchange rate' do
  it 'and isnt loged in' do
    admin = create(:admin)
    er = create(:exchange_rate, created_by: admin)

    post(recused_exchange_rate_path(er))

    expect(response).to redirect_to new_admin_session_path
  end
end
