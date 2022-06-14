# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientPerson, type: :model do
  describe '#valid?' do
    context 'when presence' do
      it 'false when full_name is empty' do
        ClientCategory.create!(name: "Bronze", discount_percent: 0)
        Client.create!(client_type: 0, client_category_id: 1)
        client_person = described_class.new(full_name: '', cpf: '12345678999', client_id: 1)

        expect(client_person.valid?).to be false
      end

      it 'false when cpf is empty' do
        ClientCategory.create!(name: "Bronze", discount_percent: 0)
        Client.create!(client_type: 0, client_category_id: 1)
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '', client_id: 1)

        expect(client_person.valid?).to be false
      end

      it 'with success' do
        ClientCategory.create!(name: "Bronze", discount_percent: 0)
        Client.create!(client_type: 0, client_category_id: 1)
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '12345678999', client_id: 1)

        expect(client_person.valid?).to be true
      end
    end

    context 'when client_person belongs to client' do
      it 'with success' do
        ClientCategory.create!(name: "Bronze", discount_percent: 0)
        Client.create!(client_type: 0, client_category_id: 1)
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '12345678999', client_id: 1)

        expect(client_person.valid?).to be true
      end
    end
  end
end