# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'are there validations?' do
    context 'with active_record' do
      it { is_expected.to have_many(:exchange_rates) }
    end

    context 'with active_model' do
      it { is_expected.to validate_presence_of(:full_name) }
      it { is_expected.to validate_presence_of(:cpf) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:password) }
    end
  end

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
    end
  end
end
