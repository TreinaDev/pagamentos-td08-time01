# frozen_string_literal: true

require 'rails_helper'

describe 'Admin sees promotion list' do
  it 'successfully' do
    admin = create(:admin)
    client_category = ClientCategory.create!(name: 'Ouro', discount_percent: 15.5)
    Promotion.create!(name: 'treina', start_date: 2.days.from_now, end_date: 3.days.from_now, bonus: 30,
                      limit_day: 40, client_category: client_category)
    Promotion.create!(name: 'dev', start_date: 4.days.from_now, end_date: 3.weeks.from_now, bonus: 10,
                      limit_day: 90, client_category: client_category)

    login_as admin
    visit root_path
    click_on 'Promoções'

    expect(page).to have_content 'treina'
    expect(page).to have_content 'dev'
    expect(page).to have_content I18n.l(2.days.from_now.to_date).to_s
    expect(page).to have_content I18n.l(2.days.from_now.to_date).to_s
    expect(page).to have_content '30'
    expect(page).to have_content '10'
    expect(page).to have_content '40'
    expect(page).to have_content '90'
    expect(page).to have_content 'Ouro'
  end

  it 'and theres no promotion registered' do
    admin = create(:admin)

    login_as admin
    visit promotions_path

    expect(page).to have_content 'Nenhuma promoção cadastrada'
  end

  it 'without be authenticated' do
    visit promotions_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
