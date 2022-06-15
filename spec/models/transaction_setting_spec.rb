# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionSetting, type: :model do
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
        expect(transaction_setting.errors[:max_credit]).to include 'deve ser maior ou igual a 0'
      end
    end
  end
end
