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
    context 'when client name isnt present' do
      it 'return false when name is empty' do
        category = build(:client_category, name: '', discount_percent: 0)

        expect(category.valid?).to be false
      end

      it 'return false when discount_percent is empty' do
        category = build(:client_category, discount_percent: '')

        expect(category.valid?).to be false
      end

      it 'return true when all fields are completed' do
        category = build(:client_category)

        expect(category.valid?).to be true
      end
    end
  end
end
