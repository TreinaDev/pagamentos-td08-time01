require 'rails_helper'

RSpec.describe Client, type: :model do
  describe "#valid?" do
    context "presence" do
      it 'false when client_type is empty' do
        client = Client.new(client_type: "")

        expect(client.valid?).to eq false
      end

      it 'true when client_type is client_person' do
        client = Client.new(client_type: 0)

        expect(client.valid?).to eq true
      end

      it 'true when client_type is client_company' do
        client = Client.new(client_type: 5)

        expect(client.valid?).to eq true
      end
    end
  end
end
