# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe 'are there validations?' do
    context 'with active_record' do
      it { is_expected.to belong_to(:created_by) }
      it { is_expected.to belong_to(:approved_by).optional }
      it { is_expected.to belong_to(:recused_by).optional }
    end

    context 'with active_model' do
      it { is_expected.to validate_presence_of(:brl_coin) }
      it { is_expected.to validate_presence_of(:register_date) }
      it { is_expected.to define_enum_for(:status) }
      it { is_expected.to validate_numericality_of(:brl_coin).is_greater_than(0) }
    end
  end

  describe '#valid?' do
    context 'when atributes arent present' do
      it 'false when attributes are not present' do
        rate = described_class.new

        expect(rate).not_to be_valid
        expect(rate.errors.full_messages_for(:register_date)).to include 'Data de registro não pode ficar em branco'
        expect(rate.errors.full_messages_for(:brl_coin)).to include 'Real não pode ficar em branco'
      end
    end

    context 'when register date isnt unique' do
      it 'false when date is repeated' do
        admin = create(:admin)
        create(:exchange_rate, register_date: 1.day.from_now, created_by: admin)
        rate = build(:exchange_rate, brl_coin: 5.1, register_date: 1.day.from_now, created_by: admin)

        rate.valid?

        expect(rate.errors.full_messages_for(:register_date)).to include 'Data de registro já está em uso'
      end
    end

    context 'when brl value isnt greater than 0' do
      it 'when brl value is negative' do
        rate = build(:exchange_rate, brl_coin: -1)

        rate.valid?

        expect(rate.errors.full_messages_for(:brl_coin)).to include 'Real deve ser maior que 0'
      end

      it 'when brl value is 0' do
        rate = build(:exchange_rate, brl_coin: 0)

        rate.valid?

        expect(rate.errors.full_messages_for(:brl_coin)).to include 'Real deve ser maior que 0'
      end
    end
  end

  describe '#register_date_isnt_in_past' do
    context 'when register date is in the past' do
      it 'register date is yesterday' do
        rate = build(:exchange_rate, register_date: 3.days.ago)

        rate.valid?

        expect(rate.errors.include?(:register_date)).to be true
        expect(rate.errors[:register_date]).to include 'não pode ser no passado'
      end
    end
  end

  describe '#set_status_exchange_rate' do
    context 'when is the first exchange rate register' do
      it 'set approved status' do
        admin = create(:admin)
        rate = create(:exchange_rate, brl_coin: 50, created_by: admin)

        expect(rate.status).to eq 'approved'
        expect(rate.approved_by).to eq admin
      end

      it 'when variation is less than 10%' do
        admin = create(:admin)
        create(:exchange_rate, brl_coin: 5, created_by: admin, register_date: 2.days.from_now)
        rate = create(:exchange_rate, brl_coin: 5.1, created_by: admin, register_date: 3.days.from_now)

        expect(rate.status).to eq 'approved'
        expect(rate.approved_by).to eq admin
      end
    end

    context 'when variation is greater than 10%' do
      it 'set pending status' do
        admin = create(:admin)
        create(:exchange_rate, brl_coin: 5, created_by: admin)
        rate = create(:exchange_rate, register_date: 2.days.from_now, brl_coin: 6, created_by: admin)

        expect(rate.status).to eq 'pending'
      end
    end
  end

  describe '#max_variation?' do
    it 'true when variation is lower than 10%' do
      admin = create(:admin)
      create(:exchange_rate, brl_coin: 5, created_by: admin)
      rate = create(:exchange_rate, register_date: 3.days.from_now, brl_coin: 5.2, created_by: admin)

      expect(rate.max_variation?).to be true
    end

    it 'false when variation is greater than 10%' do
      admin = create(:admin)
      create(:exchange_rate, brl_coin: 5, created_by: admin)
      rate = create(:exchange_rate, register_date: 3.days.from_now, brl_coin: 6, created_by: admin)

      expect(rate.max_variation?).to be false
    end
  end

  describe '#prevent_approvemment_by_creator' do
    it 'add error when approved by is nil' do
      admin = create(:admin)
      create(:exchange_rate, brl_coin: 5, created_by: admin)
      rate = create(:exchange_rate, brl_coin: 6, status: 'pending', created_by: admin, register_date: 3.days.from_now)

      rate.status = 'approved'
      rate.valid?

      expect(rate.errors[:exchange_rate]).to include 'não pode ser aprovada sem um administrador'
    end

    it 'add error when approved_by is equal to created by' do
      admin = create(:admin)
      create(:exchange_rate, brl_coin: 5, created_by: admin)
      rate = create(:exchange_rate, brl_coin: 6, status: 'pending', created_by: admin, register_date: 3.days.from_now)

      rate.status = 'approved'
      rate.approved_by = admin
      rate.valid?

      expect(rate.errors[:exchange_rate]).to include 'não pode ser aprovada pelo mesmo administrador que registrou'
    end
  end

  describe '#prevent_recuse_by_nil' do
    it 'add error when recused_by is nil' do
      admin = create(:admin)
      create(:exchange_rate, brl_coin: 5, created_by: admin)
      rate = create(:exchange_rate, brl_coin: 6, status: 'pending', created_by: admin, register_date: 3.days.from_now)

      rate.status = 'recused'
      rate.valid?
      expect(rate.errors[:exchange_rate]).to include 'não pode ser recusada sem um administrador'
    end
  end
end
