require 'rails_helper'

RSpec.describe Client, type: :model do
  describe "#valid?" do
    context "presence" do
      it 'false when client_type is empty' do
        client = Client.new(client_type: "")

        expect(client.valid?).to eq false
      end

      it 'true when client_type is not empty' do
        client = Client.new(client_type: "Pessoa física")

        expect(client.valid?).to eq true
      end

      it 'false when client_type is different to Pessoa física or Pessoa jurídica' do
        client = Client.new(client_type: "Banana")

        expect(client.valid?).to eq false
      end
    end
  end
end
