# frozen_string_literal: true

require 'rails_helper'

describe 'Admin views client category' do
  it 'with success' do
    admin = Admin.create(email: 'example@userubis.com.br', password: 'password', password_confirmation: 'password',
                         full_name: 'Pedrinho Junior Gomes', cpf: '12345678944')

    login_as(admin)
    visit client_categories_path

    expect(page).to have_content 'Categoria de Clientes'
  end

  it 'and see all client categories' do
    admin = Admin.create(email: 'example@userubis.com.br', password: 'password', password_confirmation: 'password',
                         full_name: 'Pedrinho Junior Gomes', cpf: '12345678944')
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
    admin = Admin.create(email: 'example@userubis.com.br', password: 'password', password_confirmation: 'password',
                         full_name: 'Pedrinho Junior Gomes', cpf: '12345678944')

    login_as(admin)
    visit client_categories_path

    expect(page).to have_content 'Categoria de Clientes'
    expect(page).to have_content 'Não há categoria cadastrada'
  end

  it 'access client_category without be authenticated' do
    visit client_categories_path

    expect(page).to have_current_path new_admin_session_path, ignore_query: true
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
