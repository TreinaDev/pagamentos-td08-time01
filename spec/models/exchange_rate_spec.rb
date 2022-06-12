# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe '#valid?' do
    context 'when atributes arent present' do
      it 'false when attributes are not present' do
        er = described_class.new

        expect(er).not_to be_valid
        expect(er.errors.full_messages_for(:register_date)).to include 'Data de registro não pode ficar em branco'
        expect(er.errors.full_messages_for(:brl_coin)).to include 'Real não pode ficar em branco'
      end
    end

    context 'when regiter date isnt uniq' do
      it 'false when date is repeated' do
        admin = Admin.create!(email: 'b@userubis.com.br', full_name: 'Junior', cpf: '510.695.623-20',
                              password: '123456')
        create(:exchange_rate, register_date: 1.day.from_now, created_by: admin)
        er = build(:exchange_rate, brl_coin: 5.1, register_date: 1.day.from_now)

        er.valid?

        expect(er.errors.full_messages_for(:register_date)).to include 'Data de registro já está em uso'
      end
    end

    context 'when brl value is lower than 1' do
      it 'false when brl value is lower then 1' do
        er = build(:exchange_rate, brl_coin: 0)

        er.valid?

        expect(er.errors.full_messages_for(:brl_coin)).to include 'Real deve ser maior que 1'
      end
    end
  end

  describe '#register_date_is_future' do
    context 'when register date is in the past' do
      it 'register date is yesterday' do
        er = build(:exchange_rate, register_date: 1.day.ago)

        er.valid?

        expect(er.errors.include?(:register_date)).to be true
        expect(er.errors.full_messages_for(:register_date)).to include 'Data de registro deve ser futura'
      end
    end
  end

  describe '#set_status_exchange_rate' do
    context 'when is the first exchange rate register' do
      it 'set approved status' do
        admin = Admin.create!(email: 'b@userubis.com.br', full_name: 'Junior', cpf: '510.695.623-20',
                              password: '123456')
        er = create(:exchange_rate, brl_coin: 50, created_by: admin)

        expect(er.status).to eq 'approved'
      end
    end

    context 'when variation is greater than 10%' do
      it 'set pending status' do
        admin = Admin.create!(email: 'b@userubis.com.br', full_name: 'Junior', cpf: '510.695.623-20',
                              password: '123456')
        create(:exchange_rate, brl_coin: 5, created_by: admin)
        er = create(:exchange_rate, register_date: 2.days.from_now, brl_coin: 6, created_by: admin)

        expect(er.status).to eq 'pending'
      end
    end
  end

  describe '#max_variation?' do
    it 'true when variation is lower than 10%' do
      admin = Admin.create!(email: 'b@userubis.com.br', full_name: 'Junior', cpf: '510.695.623-20', password: '123456')
      create(:exchange_rate, brl_coin: 5, created_by: admin)
      er = create(:exchange_rate, register_date: 3.days.from_now, brl_coin: 5.2, created_by: admin)

      expect(er.max_variation?).to be true
    end

    it 'false when variation is greater than 10%' do
      admin = Admin.create!(email: 'b@userubis.com.br', full_name: 'Junior', cpf: '510.695.623-20', password: '123456')
      create(:exchange_rate, brl_coin: 5, created_by: admin)
      er = create(:exchange_rate, register_date: 3.days.from_now, brl_coin: 6, created_by: admin)

      expect(er.max_variation?).to be false
    end
  end
end
