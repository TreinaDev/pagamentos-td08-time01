# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientBonusBalance, type: :model do
  describe '#valid?' do
    context 'when presence' do
      it 'false when attributes are missing' do
        client_bonus_balance = build(:client_bonus_balance, bonus_value: '', expire_date: '', client_id: '')

        expect(client_bonus_balance.valid?).to be false
        expect(client_bonus_balance.errors[:bonus_value]).to include 'não pode ficar em branco'
        expect(client_bonus_balance.errors[:expire_date]).to include 'não pode ficar em branco'
        expect(client_bonus_balance.errors[:client]).to include 'é obrigatório(a)'
      end

      it 'true when attributes are present' do
        client_category = create(:client_category)
        client = Client.create!(client_type: 0, client_category_id: client_category.id)
        create(:client_person, client_id: client.id)
        client_bonus_balance = build(:client_bonus_balance, client_id: client.id)

        expect(client_bonus_balance.valid?).to be true
      end
    end

    context 'when greater than or equal to' do
      it 'when expire date is in the past' do
        client_bonus_balance = build(:client_bonus_balance, expire_date: Date.yesterday)

        client_bonus_balance.valid?

        expect(client_bonus_balance.errors[:expire_date]).to include 'não pode ser no passado'
      end

      it 'when bonus value is less than zero' do
        client_bonus_balance = build(:client_bonus_balance, bonus_value: -1)

        client_bonus_balance.valid?

        expect(client_bonus_balance.errors[:bonus_value]).to include 'deve ser maior ou igual a 0'
      end

      it 'true when attributes are corrects' do
        client_category = create(:client_category)
        client = Client.create!(client_type: 0, client_category_id: client_category.id)
        create(:client_person, client_id: client.id)
        client_bonus_balance = build(:client_bonus_balance, client_id: client.id)

        expect(client_bonus_balance.valid?).to be true
      end
    end
  end
end
