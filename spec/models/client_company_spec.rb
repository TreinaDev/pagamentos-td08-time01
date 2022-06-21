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
        client_company = described_class.new(company_name: 'ACME LTDA', cnpj: '07638546899424', client_id: client.id)

        expect(client_company.valid?).to be true
      end

      it 'false when attributes are empty' do
        client_category = ClientCategory.create!(name: 'Bronze', discount_percent: 0)
        Client.create!(client_type: 5, client_category_id: client_category.id)
        client_company = described_class.new(company_name: '', cnpj: '', client_id: '')

        expect(client_company.valid?).to be false
        expect(client_company.errors[:company_name]).to include 'não pode ficar em branco'
        expect(client_company.errors[:cnpj]).to include 'não pode ficar em branco'
        expect(client_company.errors[:client]).to include 'é obrigatório(a)'
      end
    end

    context 'when CNPJ already on use' do
      it 'unsuccessfully when CNPJ is not unique' do
        client_category = create(:client_category)
        client = Client.create(client_type: 5, client_category_id: client_category.id)
        client_company_one = create(:client_company, client_id: client.id)
        client_company_two = build(:client_company, client_id: client.id, cnpj: client_company_one.cnpj)

        expect(client_company_two.valid?).to be false
        expect(client_company_two.errors[:cnpj]).to include 'já está em uso'
      end

      it 'successfully when CNPJ is unique' do
        client_category = create(:client_category)
        client = Client.create(client_type: 5, client_category_id: client_category.id)
        create(:client_company, client_id: client.id)
        client_company_two = build(:client_company, client_id: client.id)

        expect(client_company_two.valid?).to be true
      end
    end
  end
end
