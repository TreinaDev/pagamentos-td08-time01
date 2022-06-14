# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  describe '#valid?' do
    context 'when presence is missing' do
      it 'false when client_type is empty' do
        ClientCategory.create!(name: "Bronze", discount_percent: 0)
        client = described_class.new(client_type: '', client_category_id: 1)

        expect(client.valid?).to be false
      end

      it 'true when client_type is client_person' do
        ClientCategory.create!(name: "Bronze", discount_percent: 0)
        client = described_class.new(client_type: 0, client_category_id: 1)

        expect(client.valid?).to be true
      end

      it 'true when client_type is client_company' do
        ClientCategory.create!(name: "Bronze", discount_percent: 0)
        client = described_class.new(client_type: 5, client_category_id: 1)

        expect(client.valid?).to be true
      end
    end

    context "when client belongs to client_category" do
      it "with success" do
        ClientCategory.create!(name: "Bronze", discount_percent: 0)
        client = described_class.new(client_type: 0, client_category_id: 1)

        expect(client.valid?).to be true
      end

      it "false when client_category_id is empty" do
        client = described_class.new(client_type: 0, client_category_id: "")

        expect(client.valid?).to be false
      end
    end
  end
end
