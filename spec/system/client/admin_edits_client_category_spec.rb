# frozen_string_literal: true

require 'rails_helper'

describe 'Admin edits client category' do
  it 'with success' do
    admin = create(:admin)
    category = create(:client_category, discount_percent: 10, name: 'Platinum BLACK VIP plus')
    create(:client_person, full_name: 'Jubeba das Dores')

    login_as(admin)
    visit root_path
    click_on 'Clientes'
    # print save_page
    click_on 'Editar'
    select 'Platinum BLACK VIP plus', from: 'Categoria de cliente'
    click_on 'Atualizar'

    expect(page).to have_current_path clients_path
    expect(page).to have_content 'Cliente atualizado com sucesso'
    expect(page).to have_content "#{category.name} - 10.0%"
  end

  it 'no authentication' do
    visit clients_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
