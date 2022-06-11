require 'rails_helper'

describe 'Admin views client category' do
  it 'with success' do
    # admin = Admin.create(email: 'example@userubis.com.br', password: 'password', password_confirmation: 'password', full_name: 'Pedrinho Junior Gomes', cpf: '123.456.789-44')

    # login_as(admin)
    visit client_categories_path

    expect(page).to have_content 'Categoria de Clientes'
  end

  it 'and see all client categories' do
    ClientCategory.create!(name: "Bronze", discount_percent: 0)
    ClientCategory.create!(name: "Ouro", discount_percent: 10)

    visit client_categories_path

    expect(page).to have_content "Bronze"
    expect(page).to have_content "0"
    expect(page).to have_content "Ouro"
    expect(page).to have_content "10"
  end

  it 'without any client categories' do
    visit client_categories_path

    expect(page).to have_content 'Categoria de Clientes'
    expect(page).to have_content 'Não há categoria cadastrada'
  end

  it 'access new_client_category page' do
    # admin = Admin.create(email: 'example@userubis.com.br', password: 'password', password_confirmation: 'password', full_name: 'Pedrinho Junior Gomes', cpf: '12345678944')

    visit client_categories_path
    click_on 'Cadastrar categoria'
    
    expect(current_path).to eq new_client_category_path
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Porcentagem de desconto'
  end

  it 'return to client_categories_path' do
    # admin = Admin.create(email: 'example@userubis.com.br', password: 'password', password_confirmation: 'password', full_name: 'Pedrinho Junior Gomes', cpf: '12345678944')

    visit new_client_category_path
    click_on 'Voltar'
    
    expect(page).to have_content 'Não há categoria cadastrada'
    expect(page).to have_content 'Categoria de Clientes'
  end
end