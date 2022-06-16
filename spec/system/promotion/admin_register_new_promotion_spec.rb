# frozen_string_literal: true

require 'rails_helper'

describe 'Admin register new promotion' do
  it 'with success' do
    admin = create(:admin)
    ClientCategory.create!(name: 'bronze', discount_percent: 15.5)
    ClientCategory.create!(name: 'ouro', discount_percent: 20)

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Cadastrar promoção'
    fill_in 'Nome', with: 'Dia das mães'
    fill_in 'Data de início', with: 2.days.from_now
    fill_in 'Data de encerramento', with: 1.week.from_now
    fill_in 'Desconto(%)', with: 10
    fill_in 'Prazo para uso', with: 90
    select 'ouro', from: 'Categoria de cliente'
    click_on 'Cadastrar'

    expect(page).to have_content 'Promoção cadastrada com sucesso'
    expect(page).to have_current_path promotions_path, ignore_query: true
    expect(page).to have_content 'Dia das mães'
    expect(page).to have_content I18n.l(2.days.from_now.to_date).to_s
    expect(page).to have_content I18n.l(1.week.from_now.to_date).to_s
    expect(page).to have_content '10'
    expect(page).to have_content '90'
    expect(page).to have_content 'ouro'
    expect(Promotion.last.client_category.name).to eq 'ouro'
  end

  it 'and doesnt fill all field' do
    admin = create(:admin)
    ClientCategory.create!(name: 'bronze', discount_percent: 15.5)
    ClientCategory.create!(name: 'ouro', discount_percent: 20)

    login_as admin
    visit new_promotion_path
    fill_in 'Nome', with: ''
    fill_in 'Desconto(%)', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Erro ao cadastrar promoção'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Desconto(%) não pode ficar em branco'
  end

  it 'and needs to be logged in' do
    visit new_promotion_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
