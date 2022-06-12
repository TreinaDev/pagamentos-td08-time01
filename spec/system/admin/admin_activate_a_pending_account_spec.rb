# frozen_string_literal: true

require 'rails_helper'

describe 'Admin see all pending accounts' do
  it 'a visitor access the application' do
    visit root_path

    expect(page).not_to have_content 'Pendências'
  end

  it 'and dont have pendencies' do
    admin = Admin.create!(full_name: 'Felipe Ferreira', cpf: '64262244563',
                          email: 'feferreira556@userubis.com.br', password: '203942',
                          status: 5)

    login_as admin
    visit root_path
    click_on 'Pendências'

    expect(page).to have_content 'Administradores pendentes'
    expect(page).to have_content 'O Sistema não possui administradores pendentes'
  end

  it 'and see all pending accounts' do
    Admin.create!(full_name: 'José Arantes', cpf: '24365465686',
                  email: 'jose@userubis.com.br', password: '123464',
                  status: 0)
    Admin.create!(full_name: 'Lucio Santos', cpf: '06001818398',
                  email: 'lucio22@userubis.com.br', password: '239102',
                  status: 0)
    admin = Admin.create!(full_name: 'Felipe Ferreira', cpf: '64262244563',
                          email: 'feferreira556@userubis.com.br', password: '203942',
                          status: 5)

    login_as admin
    visit root_path
    click_on 'Pendências'

    expect(page).to have_content 'José Arantes'
    expect(page).to have_content 'jose@userubis.com.br'
    expect(page).to have_content '243.654.656-86'
    expect(page).to have_content 'Lucio Santos'
    expect(page).to have_content 'lucio22@userubis.com.br'
    expect(page).to have_content '060.018.183-98'
    expect(page).to have_content 'Permissões 0/2'
    expect(page).to have_button 'Aceitar Usuário'
  end

  it 'and accept a pending account' do
    active = Admin.create!(full_name: 'Lucio Santos', cpf: '06001818398',
                           email: 'lucio22@userubis.com.br', password: '239102',
                           status: 5)
    pending_admin = Admin.create!(full_name: 'José Arantes', cpf: '24365465686',
                                  email: 'jose@userubis.com.br', password: '123464',
                                  status: 0)
    AdminPermission.create!(admin_id: pending_admin.id, active_admin: active.id)
    admin = Admin.create!(full_name: 'Felipe Ferreira', cpf: '64262244563',
                          email: 'feferreira556@userubis.com.br', password: '203942',
                          status: 5)

    login_as admin
    visit root_path
    click_on 'Pendências'
    click_on 'Aceitar Usuário'

    expect(page).to have_content 'Permissão concedida a um administrador pendente'
    expect(page).not_to have_content 'José Arantes'
    expect(page).not_to have_content 'jose@userubis.com.br'
    expect(page).not_to have_content '243.654.656-86'
  end
end