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
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = Client.create!(client_type: 5, client_category_id: client_category.id)
        client_company = described_class.new(company_name: 'ACME LTDA', cnpj: '12345678998745', client_id: client.id)

        expect(client_company.valid?).to be true
      end

      it 'false when company_name is empty' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = Client.create!(client_type: 5, client_category_id: client_category.id)
        client_company = described_class.new(company_name: '', cnpj: '12345678998745', client_id: client.id)

        expect(client_company.valid?).to be false
      end

      it 'false when cnpj is empty' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = Client.create!(client_type: 5, client_category_id: client_category.id)
        client_company = described_class.new(company_name: 'ACME LTDA', cnpj: '', client_id: client.id)

        expect(client_company.valid?).to be false
      end
    end

    context 'client_company belongs to client' do
      it 'with success' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client = Client.create!(client_type: 5, client_category_id: client_category.id)
        client_company = described_class.new(company_name: 'Pedro Gomes', cnpj: '11234567910111', client_id: client.id)

        expect(client_company.valid?).to be true
      end

      it 'false when client_id is empty' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        client_company = described_class.new(company_name: 'Pedro Gomes', cnpj: '11234567910111', client_id: '')

        expect(client_company.valid?).to be false
      end
    end
  end
end
