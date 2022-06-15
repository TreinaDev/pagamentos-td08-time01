# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  describe '#valid?' do
    context 'when presence is missing' do
      it 'false when client_type is empty' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = described_class.new(client_type: '', client_category_id: client_category.id)

        expect(client.valid?).to be false
      end

      it 'true when client_type is client_person' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = described_class.new(client_type: 0, client_category_id: client_category.id)

        expect(client.valid?).to be true
      end

      it 'true when client_type is client_company' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = described_class.new(client_type: 5, client_category_id: client_category.id)

        expect(client.valid?).to be true
      end
    end

    context 'when client should belong to clients' do
      it 'creates successfully' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = described_class.new(client_type: 0, client_category_id: client_category.id)

        expect(client.valid?).to be true
      end

      it 'unsuccessfully when client not present' do
        client = described_class.new(client_type: 0, client_category_id: '')

        expect(client.valid?).to be false
      end
    end
  end
end
