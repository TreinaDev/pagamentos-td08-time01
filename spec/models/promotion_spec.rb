# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Promotion, type: :model do
  describe '#valid?' do
    context 'when atributes arent present' do
      it 'promotion should not be valid' do
        promotion = described_class.new

        expect(promotion).not_to be_valid
        expect(promotion.errors.full_messages_for(:name)).to include 'Nome não pode ficar em branco'
        expect(promotion.errors.full_messages_for(:start_date)).to include 'Data de início não pode ficar em branco'
        expect(promotion.errors.full_messages_for(:end_date)).to include 'Data de encerramento não pode ficar em branco'
        expect(promotion.errors.full_messages_for(:discount_percent)).to include 'Desconto(%) não pode ficar em branco'
        expect(promotion.errors.full_messages_for(:limit_day)).to include 'Prazo para uso não pode ficar em branco'
        expect(promotion.errors.full_messages).to include 'Client category é obrigatório(a)'
      end
    end

    context 'when start date is after end date' do
      it 'promotion should not be valid' do
        promotion = build(:promotion, start_date: 3.days.from_now, end_date: 1.day.from_now)

        expect(promotion).not_to be_valid
        expect(promotion.errors.full_messages_for(:start_date)).to include
        'Data de início deve ser menor que data de encerramento'
      end
    end

    context 'when discount_percent and limit_day are less than 1' do
      it 'promotion should not be valid' do
        promotion = build(:promotion, discount_percent: 0, limit_day: 0)

        expect(promotion).not_to be_valid
        expect(promotion.errors[:discount_percent]).to include 'deve ser maior ou igual a 1'
        expect(promotion.errors.full_messages_for(:limit_day)).to include
        'Prazo para uso deve ser maior ou igual a 1'
      end
    end

    context 'when limit_day arent a integer number' do
      it 'promotion should not be valid' do
        promotion = build(:promotion, limit_day: 2.8)

        expect(promotion).not_to be_valid
        expect(promotion.errors.full_messages_for(:limit_day)).to include 'Prazo para uso não é um número inteiro'
      end
    end

    context 'when start and end date are not unique in client category scope' do
      it 'promotion should not be valid' do
        client_category = create(:client_category)
        create(:promotion, start_date: Date.tomorrow, end_date: 1.week.from_now, client_category_id: client_category.id)
        promotion = build(:promotion, start_date: Date.tomorrow, end_date: 1.week.from_now,
                                      client_category_id: client_category.id)

        expect(promotion).not_to be_valid
        expect(promotion.errors.full_messages_for(:start_date)).to include 'Data de início já está em uso'
        expect(promotion.errors.full_messages_for(:end_date)).to include 'Data de encerramento já está em uso'
      end
    end

    context 'when start date is on the past' do
      it 'promotion should not be valid' do
        promotion = build(:promotion, start_date: 3.days.ago)

        expect(promotion).not_to be_valid
        expect(promotion.errors.full_messages_for(:start_date)).to include 'Data de início não pode ser no passado'
      end
    end
  end
end
