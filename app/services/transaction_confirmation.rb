# frozen_string_literal: true

class TransactionConfirmation
  def self.send_response(code, status)
    transaction_params = {
      transaction: {
        code: code,
        status: status,
        error_type: SetErrorType.perform(status)
      }
    }

    Faraday.patch('http://localhost:3000/api/v1/payment_results', transaction_params.as_json)
  end
end
