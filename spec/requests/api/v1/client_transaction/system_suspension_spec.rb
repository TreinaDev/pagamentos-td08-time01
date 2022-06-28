# frozen_string_literal: true

require 'rails_helper'

describe 'POST /api/v1/client_transaction' do
  context 'when there isnt the valid exchange rate' do
    it 'transaction is not created' do
      create(:transaction_setting, max_credit: 50_000)
      create(:client_person, cpf: '06001818398')

      attributes = {
        cpf: '06001818398',
        client_transaction: {
          credit_value: 10_000,
          type_transaction: 'transaction_order'
        }
      }

      post api_v1_client_transactions_path, params: attributes

      expect(response).to have_http_status :not_implemented
      expect(ClientTransaction.count).to eq 0
      expect(response.body).to eq 'Não existe uma taxa de câmbio válida, '\
                                  'por favor contate a API de pagamento.'
    end
  end
end
