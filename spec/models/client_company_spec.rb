# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientCompany, type: :model do
  describe 'are there validations?' do
    context 'with active_model' do
      it { is_expected.to validate_presence_of(:company_name) }
      it { is_expected.to validate_presence_of(:cnpj) }
    end
  end

  describe '#valid?' do
    context 'when presence' do
      it 'with success' do
        client_company = described_class.new(company_name: 'ACME LTDA', cnpj: '12345678998745')

        expect(client_company.valid?).to be true
      end

      it 'false when company_name is empty' do
        client_company = described_class.new(company_name: '', cnpj: '12345678998745')

        expect(client_company.valid?).to be false
      end

      it 'false when cnpj is empty' do
        client_company = described_class.new(company_name: 'ACME LTDA', cnpj: '')

        expect(client_company.valid?).to be false
      end
    end
  end
end
