# frozen_string_literal: true

require 'rails_helper'

describe 'Admin register new exchange rate' do
  it 'successfully' do
    admin = create(:admin)

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Cadastrar Taxa'
    fill_in 'Data de registro', with: I18n.l(3.days.from_now.to_date)
    fill_in 'Real', with: 5.10
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa de câmbio registrada com sucesso'
    expect(page).to have_content 'Taxa de câmbio'
    expect(page).to have_content I18n.l(3.days.from_now.to_date)
    expect(page).to have_content '1 rubi equivale a R$ 5,10 reais'
    expect(page).to have_current_path exchange_rates_path
    expect(ExchangeRate.last.created_by).to eq admin
  end

  it 'when there is no approved or pending fee for the same day' do
    admin = create(:admin, status: :active)
    admin_two = create(:admin, status: :active)

    Timecop.freeze(Time.zone.yesterday) do
      create(:exchange_rate, rubi_coin: 1, brl_coin: 2, register_date: Time.zone.today,
                             status: 'approved', created_by: admin, approved_by: admin_two)
    end

    create(:exchange_rate, rubi_coin: 1, brl_coin: 3, register_date: Time.zone.today,
                           status: 'recused', created_by: admin, recused_by: admin_two)

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Cadastrar Taxa'
    fill_in 'Data de registro', with: I18n.l(Time.zone.today)
    fill_in 'Real', with: 0.50
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa de câmbio registrada com sucesso'
    expect(page).to have_content I18n.l(Time.zone.today)
    expect(page).to have_content '1 rubi equivale a R$ 3,00 reais Recusada'
    expect(page).to have_content '1 rubi equivale a R$ 0,50 reais Aprovada'
  end

  it 'when there is a pending fee for the same day' do
    admin = create(:admin, status: :active)
    admin_two = create(:admin, status: :active)

    Timecop.freeze(Time.zone.yesterday) do
      create(:exchange_rate, rubi_coin: 1, brl_coin: 2, register_date: Time.zone.today,
                             status: 'approved', created_by: admin, approved_by: admin_two)
    end

    create(:exchange_rate, rubi_coin: 1, brl_coin: 3, register_date: Time.zone.today,
                           status: 'pending', created_by: admin, approved_by: nil)
    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Cadastrar Taxa'
    fill_in 'Data de registro', with: I18n.l(Time.zone.today)
    fill_in 'Real', with: 0.50
    click_on 'Cadastrar'

    expect(page).to have_content 'Data de registro já está em uso'
    expect(ExchangeRate.count).to eq 2
  end

  it 'when there is an approved rate for the same day' do
    admin = create(:admin, status: :active)
    admin_two = create(:admin, status: :active)

    create(:exchange_rate, rubi_coin: 1, brl_coin: 2, register_date: Time.zone.today,
                           status: 'approved', created_by: admin, approved_by: admin_two)

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Cadastrar Taxa'
    fill_in 'Data de registro', with: I18n.l(Time.zone.today)
    fill_in 'Real', with: 0.50
    click_on 'Cadastrar'

    expect(page).to have_content 'Data de registro já está em uso'
    expect(ExchangeRate.count).to eq 1
  end

  it 'and variation is less than 10%' do
    admin = create(:admin, status: :active)
    admin_two = create(:admin, status: :active)

    Timecop.freeze(Time.zone.yesterday) do
      create(:exchange_rate, rubi_coin: 1, brl_coin: 2, register_date: Time.zone.today,
                             status: 'approved', created_by: admin, approved_by: admin_two)
    end

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Cadastrar Taxa'
    fill_in 'Data de registro', with: '25/08/2022'
    fill_in 'Real', with: 1
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa de câmbio registrada com sucesso'
    expect(page).to have_content '1 rubi equivale a R$ 1,00 reais Aprovada'
    expect(ExchangeRate.last.status).to eq 'approved'
  end

  it 'and variation is greater than 10%' do
    admin = create(:admin, status: :active)
    admin_two = create(:admin, status: :active)

    Timecop.freeze(Time.zone.yesterday) do
      create(:exchange_rate, rubi_coin: 1, brl_coin: 2, register_date: Time.zone.today,
                             status: 'approved', created_by: admin, approved_by: admin_two)
    end

    login_as admin
    visit root_path
    click_on 'Taxa de câmbio'
    click_on 'Cadastrar Taxa'

    fill_in 'Data de registro', with: '25/08/2022'
    fill_in 'Real', with: 6
    click_on 'Cadastrar'

    expect(page).to have_content 'Taxa de câmbio em análise'
    expect(page).to have_content '1 rubi equivale a R$ 6,00 reais Pendente'
    expect(ExchangeRate.last.status).to eq 'pending'
  end

  it 'and doesnt fill all fields' do
    admin = create(:admin)

    login_as admin
    visit new_exchange_rate_path
    fill_in 'Data de registro', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Erro ao registrar taxa de câmbio'
    expect(page).to have_content 'Data de registro não pode ficar em branco'
  end

  it 'and needs to be logged in' do
    visit new_exchange_rate_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
