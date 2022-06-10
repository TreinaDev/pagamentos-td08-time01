# frozen_string_literal: true

require 'rails_helper'

describe 'Visitante visita a app' do
  it 'com sucesso' do
    visit root_path

    expect(page).to have_content 'Pagamentos'
  end
end
