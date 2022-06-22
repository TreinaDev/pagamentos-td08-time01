# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientCategory, type: :model do
  describe 'are there validations?' do
    context 'with active_model' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:discount_percent) }
    end
  end

  describe '#valid?' do
    context 'when client attributes are not present' do
      it 'return false' do
        category = build(:client_category, name: '', discount_percent: '')

        expect(category.valid?).to be false
        expect(category.errors[:name]).to include 'não pode ficar em branco'
        expect(category.errors[:discount_percent]).to include 'não pode ficar em branco'
      end

      it 'return true when all fields are completed' do
        category = build(:client_category)

        expect(category.valid?).to be true
      end
    end

    context 'when name already on use' do
      it 'unsuccessfully when name is not unique' do
        create(:client_category, name: 'Ouro')
        category_two = build(:client_category, name: 'ouro')

        expect(category_two.valid?).to be false
        expect(category_two.errors[:name]).to include 'já está em uso'
      end
    end
  end
end
