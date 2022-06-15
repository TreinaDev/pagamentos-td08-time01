# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    context 'with presence' do
      it 'when attributes is not present' do
        admin = described_class.new

        expect(admin).not_to be_valid
        expect(admin.errors[:full_name]).to include('não pode ficar em branco')
        expect(admin.errors[:cpf]).to include('não pode ficar em branco')
        expect(admin.errors[:email]).to include('não pode ficar em branco')
        expect(admin.errors[:password]).to include('não pode ficar em branco')
      end
    end

    context 'with format' do
      it 'when email has a wrong domain' do
        admin = build(:admin, email: 'exemplo@teste.com.br')

        expect(admin).not_to be_valid
        expect(admin.errors[:email]).to include('deve possuir o dominio @userubis.com.br')
      end

      it 'when email is invalid' do
        admin = build(:admin, email: 'isso não é um email')

        expect(admin).not_to be_valid
        expect(admin.errors[:email]).to include('não é válido')
      end

      it 'when CPF is invalid' do
        admin = build(:admin, cpf: '000')

        expect(admin).not_to be_valid
        expect(admin.errors[:cpf]).to include('não é válido')
      end
    end

    context 'with unique' do
      it 'when cpf and email is already in use' do
        first_adm = create(:admin, cpf: '75801559159', email: 'test@userubis.com.br')
        second_adm = build(:admin, email: first_adm.email, cpf: first_adm.cpf)

        expect(second_adm).not_to be_valid
        expect(second_adm.errors[:email]).to include('já está em uso')
        expect(second_adm.errors[:cpf]).to include('já está em uso')
      end
    end
  end
end
