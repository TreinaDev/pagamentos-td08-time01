require 'rails_helper'

describe 'admin access the application' do
  it 'without have account ' do
    visit root_path
    click_on 'Entrar'
    click_on 'Registrar nova conta'

    expect(page).to have_content 'Pagamentos'
    expect(page).to have_content 'Registrar conta'
    expect(page).to have_field 'Nome Completo'
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
    expect(page).to have_button 'Criar Administrador'
  end

  it 'and create an account' do
    visit root_path
    click_on 'Entrar'
    click_on 'Registrar nova conta'
    fill_in 'Nome Completo', with: 'Sérgio Silva'
    fill_in 'CPF', with: '00000000000'
    fill_in 'E-mail', with: 'sergio@userubis.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Criar Administrador'

    expect(page).not_to have_content 'Entrar'
    expect(page).to have_content 'Sérgio Silva'
    expect(page).to have_content 'sergio@userubis.com.br'
    expect(page).to have_content 'Sair'
  end

  it "with blank fields" do
    visit root_path
    click_on 'Entrar'
    click_on 'Registrar nova conta'
    fill_in 'Nome Completo', with: ''
    click_on 'Criar Administrador'

    expect(page).to have_content 'Nome Completo não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'E-mail deve possuir o dominio @userubis.com.br'
  end
end
