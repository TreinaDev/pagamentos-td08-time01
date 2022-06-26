# frozen_string_literal: true

require 'rails_helper'

describe 'Admin lists client informations' do
  it 'success' do
    admin = create(:admin)
    create(:client_person, full_name: 'Jubeba das Dores')

    login_as(admin)
    visit root_path
    click_on 'Clientes'

    expect(page).to have_content 'Jubeba das Dores'
    expect(page).to have_content '0,00'
  end

  it 'must be authenticated' do
    create(:client_person, full_name: 'Jubeba das Dores')

    visit clients_path

    expect(page).not_to have_content 'Jubeba das Dores'
    expect(page).not_to have_content '0,00'
    expect(page).to have_content 'Login'
  end
end
