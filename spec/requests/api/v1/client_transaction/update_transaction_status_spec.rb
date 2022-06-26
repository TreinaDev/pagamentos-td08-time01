# frozen_string_literal: true

require 'rails_helper'

describe 'PATCH /api/v1/payment_results' do
  context 'when client transaction is approved' do
    xit 'with client person' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)

      client_person = create(:client_person)
      client_transaction = create(:client_transaction, client: client_person.client,
                                                       type_transaction: 'buy_rubys', status: 'approved')
   
                                       
      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'approved',
          error_type: ''
        }
      }
  
      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

            
      result = TransactionConfirmation.send_response(client_transaction.code, client_transaction.status)
  
      expect(JSON.parse(result.body)["message"]).to eq 'Mensagem recebida com sucesso.'
      expect(result.status).to eq 200
    end

    xit 'with client company' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)
      client_company = create(:client_company)
      client_transaction = create(:client_transaction, client: client_company.client,
                                                       type_transaction: 'buy_rubys', status: 'approved')
      fake_response = instance_double('faraday_response', status: 200, body: json_data )

      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'approved',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      result = TransactionConfirmation.send_response(client_transaction.code, client_transaction.status)
  
      expect(JSON.parse(result.body)["message"]).to eq 'Mensagem recebida com sucesso.'
      expect(result.status).to eq 200
    end
  end

  context 'when client transaction is recused' do
    xit 'with client person' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)

      client_person = create(:client_person)
      client_transaction = create(:client_transaction, client: client_person.client, 
                                                       type_transaction: 'buy_rubys', status: 'refused')
      transaction_notification = create(:transaction_notification, description: 'fraude', client_transaction_id: client_transaction.id)

      transaction_data = {
        transaction: {
          code: client_transaction.code,
          status: 'refused',
          error_type: transaction_notification.description
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response) 
      
      result = TransactionConfirmation.send_response(client_transaction.code, client_transaction.status,
                                                     transaction_notification.description)
  
      expect(JSON.parse(result.body)["message"]).to eq 'Mensagem recebida com sucesso.'
      expect(result.status).to eq 200
    end
  end
end
