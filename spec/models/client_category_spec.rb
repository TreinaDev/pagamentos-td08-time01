require 'rails_helper'

RSpec.describe ClientCategory, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'return false when name is empty' do
        category = ClientCategory.new(name: '', discount_percent: 0)

        expect(category.valid?).to eq false
      end

      it 'return false when discount_percent is empty' do
        category = ClientCategory.new(name: 'Jacinto', discount_percent: '')

        expect(category.valid?).to eq false
      end

      it 'return true when all fields are completed' do
        category = ClientCategory.new(name: 'Jacinta', discount_percent: 7)

        expect(category.valid?).to eq true
      end
    end
  end
end
