# frozen_string_literal: true

require 'rails_helper'

describe 'admin registers client category' do
  it 'with success' do
    admin = create(:admin)

    login_as(admin)
    visit new_client_category_path
    fill_in 'Nome', with: 'Bronze'
    fill_in 'Porcentagem de desconto', with: 'Ouro'
    click_on 'Cadastrar'

    expect(page).to have_content 'Categoria criada com sucesso.'
  end

  it 'with fail' do
    admin = create(:admin)

    login_as(admin)
    visit new_client_category_path
    fill_in 'Nome',	with: 'Diamante'
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar a categoria.'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Porcentagem de desconto não pode ficar em branco'
  end

  it 'access new_client_category without be authenticated' do
    visit new_client_category_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
