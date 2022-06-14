require 'rails_helper'

describe 'Admin sees promotion list' do
  it 'successfully' do
    admin = create(:admin)
    client_category = ClientCategory.create!(name: 'ouro', discount_percent: 15.5)
    Promotion.create!(name: 'treina', start_date: 2.days.from_now, end_date: 3.days.from_now, discount_percent: 30, limit_days: 40, client_category: client_category)
    Promotion.create!(name: 'dev', start_date: 4.days.from_now, end_date: 3.weeks.from_now, discount_percent: 10, limit_days: 90, client_category: client_category)

    login_as admin
    visit root_path
    click_on 'Promoções'

    expect(page).to have_content 'treina'
    expect(page).to have_content 'dev'
    expect(page).to have_content "#{I18n.l(2.days.from_now.to_date)}"
    expect(page).to have_content "#{I18n.l(2.days.from_now.to_date)}"
    expect(page).to have_content '30'
    expect(page).to have_content '10'
    expect(page).to have_content '40'
    expect(page).to have_content '90'
    expect(page).to have_content 'ouro'
    
    
  end
end