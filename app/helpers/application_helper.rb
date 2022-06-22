# frozen_string_literal: true

module ApplicationHelper
  CLIENT_TRANSACTION_STATUS = [
    ['Pendente', :pending],
    ['Aprovar', :active],
    ['Recusar', :refused]
  ].freeze

  def options_for_client_transaction_status(selected)
    options_for_select(CLIENT_TRANSACTION_STATUS, selected)
  end
end
