# frozen_string_literal: true

require 'rails_helper'

describe 'Client transaction list' do
  it 'admin views pending transactions' do
    admin = create(:admin, status: :active)
    admin_two = create(:admin, status: :active)
    client = create(:client_person, full_name: 'Olivia Ferreira').client
    create(:client_transaction, credit_value: 10_000, status: :pending, client: client)
    create(:client_transaction, credit_value: 5_000, status: :pending, client: client)
    create(:exchange_rate, brl_coin: 10, rubi_coin: 1, status: 'approved', created_by_id: admin.id,
                           approved_by_id: admin_two.id, register_date: Time.zone.today)

    login_as(admin)
    visit root_path
    click_on 'Transações'

    expect(page).to have_content 'Olivia Ferreira'
    expect(page).to have_content 10_000
    expect(page).to have_content 5_000
    expect(page).to have_content 'Pendente'
    expect(page).to have_content 100_000
    expect(page).to have_content 50_000
    expect(page).to have_content 'Compra de rubis'
  end

  it 'admin views done transactions' do
    admin = create(:admin, status: :active)
    admin_two = create(:admin, status: :active)
    client = create(:client_company, company_name: 'Bar do seu zé').client
    create(:client_transaction, credit_value: 10_000, status: :approved, client: client)
    create(:client_transaction, credit_value: 5_000, status: :refused, client: client)
    create(:exchange_rate, brl_coin: 10, rubi_coin: 1, status: 'approved', created_by_id: admin.id,
                           approved_by_id: admin_two.id, register_date: Time.zone.today)

    login_as(admin)
    visit root_path
    click_on 'Transações'
    click_on 'Transações concluídas'

    expect(page).to have_content 'Bar do seu zé'
    expect(page).to have_content 10_000
    expect(page).to have_content 5_000
    expect(page).to have_content 100_000
    expect(page).to have_content 50_000
    expect(page).to have_content 'Aprovado'
    expect(page).to have_content 'Recusado'
    expect(page).to have_content 'Compra de rubis'
  end

  it 'admin returns to pending transactions' do
    admin = create(:admin, status: :active)
    admin_two = create(:admin, status: :active)
    client = create(:client_person, full_name: 'Olivia Ferreira').client
    create(:client_transaction, credit_value: 10_000, status: :pending, client: client)
    create(:exchange_rate, brl_coin: 10, rubi_coin: 1, status: 'approved', created_by_id: admin.id,
                           approved_by_id: admin_two.id, register_date: Time.zone.today)

    login_as(admin)
    visit root_path
    click_on 'Transações'
    click_on 'Transações concluídas'
    click_on 'Transações pendentes'

    expect(page).to have_content 'Olivia Ferreira'
    expect(page).to have_content 100_000
    expect(page).to have_content 10_000
    expect(page).to have_content 'Pendente'
    expect(page).to have_content 'Compra de rubis'
  end

  it 'does not have registered exchange rate' do
    admin = create(:admin, status: :active)
    client = create(:client_person, full_name: 'Olivia Ferreira').client
    create(:client_transaction, credit_value: 10_000, status: :pending, client: client)

    login_as(admin)
    visit root_path
    click_on 'Transações'

    expect(page).to have_content 'Sem taxa'
  end

  it 'must be logged in' do
    visit client_transactions_path

    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
  end
end
