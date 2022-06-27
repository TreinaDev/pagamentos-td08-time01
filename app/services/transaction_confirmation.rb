# frozen_string_literal: true

class TransactionConfirmation
  def self.send_response(code, status, error_type)
    error_type ||= ''

    transaction_params = {
      transaction: {
        code: code,
        status: status,
        error_type: error_type
      }
    }

    Faraday.patch('http://localhost:3000/api/v1/payment_results', transaction_params.as_json)
  end
end
