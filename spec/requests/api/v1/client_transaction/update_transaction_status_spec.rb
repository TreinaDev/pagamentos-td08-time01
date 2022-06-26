# frozen_string_literal: true

require 'rails_helper'

describe 'PATCH /api/v1/payment_results' do
  context 'when client transaction is approved' do
    it 'with client person' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)

      transaction_data = {
        transaction: {
          code: 'OAA8-TPDD',
          status: 'approved',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with('http://localhost:3000/api/v1/payment_results',
                                             transaction_data.as_json).and_return(fake_response)

      result = TransactionConfirmation.send_response('OAA8-TPDD', 'approved')

      expect(JSON.parse(result.body)['message']).to eq 'Mensagem recebida com sucesso.'
      expect(result.status).to eq 200
    end

    it 'with client company' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)

      transaction_data = {
        transaction: {
          code: 'OSA7-TPDD',
          status: 'approved',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with('http://localhost:3000/api/v1/payment_results',
                                             transaction_data.as_json).and_return(fake_response)

      result = TransactionConfirmation.send_response('OSA7-TPDD', 'approved')

      expect(JSON.parse(result.body)['message']).to eq 'Mensagem recebida com sucesso.'
      expect(result.status).to eq 200
    end
  end

  context 'when client transaction is recused' do
    it 'with client person' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)

      transaction_data = {
        transaction: {
          code: 'OSA8-TPDD',
          status: 'refused',
          error_type: 'fraud_warning'
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      result = TransactionConfirmation.send_response('OSA8-TPDD', 'refused', 'fraud_warning')

      expect(JSON.parse(result.body)['message']).to eq 'Mensagem recebida com sucesso.'
      expect(result.status).to eq 200
    end

    it 'with client company' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_success.json'))
      fake_response = instance_double('faraday_response', status: 200, body: json_data)

      transaction_data = {
        transaction: {
          code: 'OSA8-TPEA',
          status: 'refused',
          error_type: 'insufficient_funds'
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      result = TransactionConfirmation.send_response('OSA8-TPEA', 'refused', 'insufficient_funds')

      expect(JSON.parse(result.body)['message']).to eq 'Mensagem recebida com sucesso.'
      expect(result.status).to eq 200
    end
  end

  context 'when transaction code is not found on ecommerce' do
    it 'raise 404 error' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_code_not_found.json'))
      fake_response = instance_double('faraday_response', status: 404, body: json_data)

      transaction_data = {
        transaction: {
          code: '4545465A44CCCC',
          status: 'approved',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      result = TransactionConfirmation.send_response('4545465A44CCCC', 'approved')

      expect(JSON.parse(result.body)['message']).to eq 'Transação desconhecida.'
      expect(result.status).to eq 404
    end
  end

  context 'when status isnt valid' do
    it 'raise 422 error' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_invalid_status.json'))
      fake_response = instance_double('faraday_response', status: 422, body: json_data)

      transaction_data = {
        transaction: {
          code: 'OSA8-TPEA',
          status: 'invalid_status',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      result = TransactionConfirmation.send_response('OSA8-TPEA', 'invalid_status')

      expect(JSON.parse(result.body)['message']).to eq 'Status inválido.'
      expect(result.status).to eq 422
    end
  end

  context 'when status is recused but error_type field is empty' do
    it 'raise 422 error' do
      json_data = File.read(Rails.root.join('spec/support/json/transaction_confirmation_error_type_empty.json'))
      fake_response = instance_double('faraday_response', status: 422, body: json_data)

      transaction_data = {
        transaction: {
          code: 'OSA8-TPEA',
          status: 'refused',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(fake_response)

      result = TransactionConfirmation.send_response('OSA8-TPEA', 'refused')

      expect(JSON.parse(result.body)['message']).to eq "O tipo de erro não pode ficar em branco quando a transação foi recusada (status: 'refused')."
      expect(result.status).to eq 422
    end
  end

  context 'when ecommerce api is offline' do
    it 'raise 500 error' do
      error_response = double('faraday_response', status: 500, body: '{}')

      transaction_data = {
        transaction: {
          code: 'OSA8-TPEA',
          status: 'approved',
          error_type: ''
        }
      }

      allow(Faraday).to receive(:patch).with(
        'http://localhost:3000/api/v1/payment_results',
        transaction_data.as_json
      ).and_return(error_response)

      result = TransactionConfirmation.send_response('OSA8-TPEA', 'approved')

      expect(result.status).to eq 500
      expect(JSON.parse(result.body)).to be_empty
    end
  end
end
