# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionSetting, type: :model do
  describe 'are there validations?' do
    context 'with active_model' do
      it { is_expected.to validate_presence_of(:max_credit) }
      it { is_expected.to validate_numericality_of(:max_credit).is_greater_than(0) }
    end
  end

  describe '#valid?' do
    context 'with presence' do
      it 'false when max_credit is empty' do
        transaction_setting = build(:transaction_setting, max_credit: '')

        expect(transaction_setting).not_to be_valid
        expect(transaction_setting.errors[:max_credit]).to include 'não pode ficar em branco'
      end

      it 'valid when max_credit is present' do
        transaction_setting = build(:transaction_setting, max_credit: 40_000)

        expect(transaction_setting).to be_valid
      end
    end

    context 'when max_credit is less than 0' do
      it 'must be invalid' do
        transaction_setting = build(:transaction_setting, max_credit: -10)

        expect(transaction_setting).not_to be_valid
        expect(transaction_setting.errors[:max_credit]).to include 'deve ser maior que 0'
      end
    end

    context 'when max_credit is an alpha character' do
      it 'must be invalid' do
        transaction_setting = build(:transaction_setting, max_credit: 'edfni')

        expect(transaction_setting).not_to be_valid
        expect(transaction_setting.errors[:max_credit]).to include 'não é um número'
      end
    end
  end
end
