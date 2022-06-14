# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientPerson, type: :model do
  describe '#valid?' do
    context 'when presence' do
      it 'false when full_name is empty' do
        client_person = described_class.new(full_name: '', cpf: '12345678999')

        expect(client_person.valid?).to be false
      end

      it 'false when cpf is empty' do
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '')

        expect(client_person.valid?).to be false
      end

      it 'with success' do
        client_person = described_class.new(full_name: 'Pedro Gomes', cpf: '12345678999')

        expect(client_person.valid?).to be true
      end
    end
  end
end
