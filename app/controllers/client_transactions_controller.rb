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
    @client_transaction.update!(status: params[:client_transaction][:status])

    if @client_transaction.refused?
      description = params[:client_transaction][:transaction_notification][:description]

      TransactionNotification.create!(description: description, client_transaction: @client_transaction)
      TransactionConfirmation.send_response(@client_transaction.code, @client_transaction.status, 'fraud_warning')
      return redirect_to client_transactions_path, notice: 'A transação foi recusada com sucesso.'
    end

    set_client_type

    redirect_to client_transactions_path,
                notice: 'A transação foi realizada com sucesso.'
  end

  private

  def set_client_transaction
    @client_transaction = ClientTransaction.find(params[:id])
  end

  def set_client_type
    if @client_transaction.approved?
      if @client_transaction.client.client_person?
        client_type = @client_transaction.client.client_person
      elsif @client_transaction.client.client_company?
        client_type = @client_transaction.client.client_company
      end
      Check.transaction(@client_transaction.credit_value, client_type, @client_transaction)
      TransactionConfirmation.send_response(@client_transaction.code, @client_transaction.status)
    else
      # fazer um post atualizando o ecommerce
    end
  end
end
