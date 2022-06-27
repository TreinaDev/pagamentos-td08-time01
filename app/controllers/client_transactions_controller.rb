# frozen_string_literal: true

class ClientTransactionsController < ApplicationController
  before_action :set_client_transaction, only: %i[edit update]

  def index
    @client_transactions = ClientTransaction.pending
  end

  def edit
    return if @client_transaction.pending?

    redirect_to client_transactions_path, notice: 'A transação não pode ser alterada.'
  end

  def update
    transaction_data = ClientTransactionService.new(@client_transaction, set_description, set_transaction_status)

    transaction_data.perform

    case transaction_data.status
    when 200
      @client_transaction.update!(status: set_transaction_status)

      redirect_to client_transactions_path, notice: transaction_data.message
    when 404, 422, 500
      @client_transaction.pending!

      redirect_to client_transactions_path, alert: transaction_data.message
    end
  end

  private

  def set_client_transaction
    @client_transaction = ClientTransaction.find(params[:id])
  end

  def set_description
    params[:client_transaction][:transaction_notification]&.values&.last
  end

  def set_transaction_status
    params[:client_transaction][:status]
  end
end
