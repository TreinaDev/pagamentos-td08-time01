# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientTransaction, type: :model do
  describe '#valid?' do
    context 'with success' do
      it 'when all attributes is present' do
        client = create(:client_person).client
        client_transaction = build(:client_transaction, client:)

        expect(client_transaction).to be_valid
      end
    end

    context 'with presence' do
      it { is_expected.to validate_presence_of(:credit_value) }
      it { is_expected.to validate_presence_of(:transaction_date) }
      it { is_expected.to belong_to(:client) }
      it { is_expected.to define_enum_for(:status) }
      it { is_expected.to define_enum_for(:type_transaction) }
      it { is_expected.to validate_numericality_of(:credit_value).is_greater_than(0) }
    end
  end
end
