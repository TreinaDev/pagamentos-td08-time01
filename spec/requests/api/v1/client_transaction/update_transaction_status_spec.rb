# frozen_string_literal: true

require 'rails_helper'

describe 'POST /api/v1/payment_results' do
  context 'when client transaction is approved' do
    xit 'with client person' do
      client_person = create(:client_person)
      client_transaction = create(:client_transaction, client: client_person.client,
                                                       type_transaction: 'buy_rubys', status: 0)
      fake_response = instance_double('faraday_response', status: 201, body: 'Mensagem recebida com sucesso.')

      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'completed',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:post).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      # fazer post de verdade para o teste
      expect(fake_response.body).to eq 'Mensagem recebida com sucesso.'
      expect(fake_response.status).to eq 201
    end

    xit 'with client company' do
      client_company = create(:client_company)
      client_transaction = create(:client_transaction, client: client_company.client,
                                                       type_transaction: 'buy_rubys', status: 0)
      fake_response = instance_double('faraday_response', status: 201, body: 'Mensagem recebida com sucesso.')

      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'completed',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:post).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      expect(fake_response.body).to eq 'Mensagem recebida com sucesso.'
      expect(fake_response.status).to eq 201
    end
  end
end
