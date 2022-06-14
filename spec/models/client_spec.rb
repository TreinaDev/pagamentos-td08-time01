# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  describe '#valid?' do
    context 'when presence' do
      it 'false when client_typeis empty' do
        client = described_class.new(client_type: '')

        expect(client.valid?).to be false
      end

      it 'true when client_type is client_person' do
        client = described_class.new(client_type: 0)

        expect(client.valid?).to be true
      end

      it 'true when client_type is client_company' do
        client = described_class.new(client_type: 5)

        expect(client.valid?).to be true
      end
    end
  end
end
