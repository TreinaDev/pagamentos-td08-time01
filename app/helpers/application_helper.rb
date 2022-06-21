# frozen_string_literal: true

module ApplicationHelper
  # select status on ClientTransaction page form
  CLIENT_TRANSACTIO_STATUS = [
    ['Pendente', :pending],
    ['Ativo', :active],
    ['Recusado', :refused]
  ].freeze

  def options_for_client_transaction_status(selected)
    options_for_select(CLIENT_TRANSACTIO_STATUS, selected)
  end
end
