# frozen_string_literal: true

require 'rails_helper'

describe 'Admin views client category' do
  it 'with success' do
    admin = create(:admin)

    login_as(admin)
    visit root_path
    click_on 'Categoria de clientes'
    visit client_categories_path

    expect(page).to have_content 'Categoria de Clientes'
  end

  it 'and see all client categories' do
    admin = create(:admin)
    ClientCategory.create!(name: 'Bronze', discount_percent: 0)
    ClientCategory.create!(name: 'Ouro', discount_percent: 10)

    login_as(admin)
    visit client_categories_path

    expect(page).to have_content 'Bronze'
    expect(page).to have_content '0'
    expect(page).to have_content 'Ouro'
    expect(page).to have_content '10'
  end

  it 'without any client categories' do
    admin = create(:admin)

    login_as(admin)
    visit client_categories_path

    expect(page).to have_content 'Categoria de Clientes'
    expect(page).to have_content 'Não há categoria cadastrada'
  end

  it 'access new_client_category page' do
    admin = create(:admin)

    login_as(admin)
    visit client_categories_path
    click_on 'Cadastrar categoria'

    expect(page).to have_current_path new_client_category_path
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Porcentagem de desconto'
  end

  it 'return to client_categories_path' do
    admin = create(:admin)

    login_as(admin)
    visit client_categories_path

    expect(page).to have_content 'Não há categoria cadastrada'
    expect(page).to have_content 'Categoria de Clientes'
  end

  it 'access client_category without be authenticated' do
    visit client_categories_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
