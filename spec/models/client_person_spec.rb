# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientPerson, type: :model do
  describe 'are there validations?' do
    context 'with active_model' do
      it { is_expected.to validate_presence_of(:full_name) }
      it { is_expected.to validate_presence_of(:cpf) }
    end
  end

  describe '#valid?' do
    context 'when presence' do
      it 'false when full_name is empty' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = Client.create!(client_type: 0, client_category_id: client_category.id)
        client_person = described_class.new(full_name: '', cpf: '12345678999', client_id: client.id)

        expect(client_person.valid?).to be false
      end

      it 'false when cpf is empty' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = Client.create!(client_type: 0, client_category_id: client_category.id)
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '', client_id: client.id)

        expect(client_person.valid?).to be false
      end

      it 'with success' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = Client.create!(client_type: 0, client_category_id: client_category.id)
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '53533989550', client_id: client.id)

        expect(client_person.valid?).to be true
      end
    end

    context 'when client_person should belong to client' do
      it 'creates successfully' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = Client.create!(client_type: 0, client_category_id: client_category.id)
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '53533989550', client_id: client.id)

        expect(client_person.valid?).to be true
      end

      it 'unsuccessfully when client not present' do
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '53533989550', client_id: '')

        expect(client_person.valid?).to be false
      end
    end

    context 'when CPF already on use' do
      it 'unsuccessfully when CPF is not unique' do
        client_category = create(:client_category)
        client = Client.create(client_type: 0, client_category_id: client_category.id)
        client_person_one = create(:client_person, client_id: client.id)
        client_person_two = build(:client_person, client_id: client.id, cpf: client_person_one.cpf)
            
        expect(client_person_two.valid?).to be false
      end

      it 'successfully when CPF is unique' do
        client_category = create(:client_category)
        client = Client.create!(client_type: 0, client_category_id: client_category.id)
        client_person_one = create(:client_person, client_id: client.id)
        client_person_two = build(:client_person, client_id: client.id)
            
        expect(client_person_two.valid?).to be true
      end
    end
  end 
end
