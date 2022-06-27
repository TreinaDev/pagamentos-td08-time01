# frozen_string_literal: true

class SetErrorType
  def self.perform(status)
    return '' if status == 'approved'

    'fraud_warning'
  end
end
