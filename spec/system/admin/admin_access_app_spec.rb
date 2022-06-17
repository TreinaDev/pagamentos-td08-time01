# frozen_string_literal: true

require 'rails_helper'

describe 'admin access the application' do
  it 'and create an account' do
    visit root_path
    click_on 'Entrar'
    click_on 'Registrar nova conta'
    fill_in 'Nome Completo', with: 'Sérgio Silva'
    fill_in 'CPF', with: '94934892303'
    fill_in 'E-mail', with: 'sergio@userubis.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Criar Administrador'

    expect(page).to have_content 'Apenas administradores ativos tem a permissão de acessar a aplicação de pagamentos'
    expect(page).not_to have_content 'Pendências'
  end

  it 'and log in' do
    create(:admin, email: 'sergio@userubis.com.br', password: '123456', status: 5)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'sergio@userubis.com.br'
    fill_in 'Senha', with: '123456'
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_content 'Pendências'
  end

  it 'with blank fields' do
    visit root_path
    click_on 'Entrar'
    click_on 'Registrar nova conta'
    fill_in 'Nome Completo', with: ''
    click_on 'Criar Administrador'

    expect(page).to have_content 'Nome Completo não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).to have_content 'E-mail deve possuir o dominio @userubis.com.br'
  end

  it 'and sign out' do
    admin = create(:admin)
    login_as admin
    visit root_path
    click_on 'Sair'

    expect(page).to have_link 'Entrar'
  end
end
