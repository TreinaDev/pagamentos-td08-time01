# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionNotification, type: :model do
  describe '#valid?' do
    context 'with presence' do
      it { is_expected.to belong_to(:client_transaction) }
      it { is_expected.to validate_presence_of(:description) }

      it 'when describe is empty' do
        client = create(:client_person).client
        client_transaction = build(:client_transaction, client: client)
        transaction_notification = build(:transaction_notification, description: '',
                                                                    client_transaction_id: client_transaction.id)

        expect(transaction_notification.valid?).to be false
        expect(transaction_notification.errors[:description]).to include 'não pode ficar em branco'
      end
    end
  end
end
