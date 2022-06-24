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

    set_client_type

    redirect_to client_transactions_path,
                notice: 'A transação foi realizada com sucesso.'
  end

  private

  def set_client_transaction
    @client_transaction = ClientTransaction.find(params[:id])
  end

  def set_client_type
    if @client_transaction.active?
      if @client_transaction.client.client_person?
        client_type = @client_transaction.client.client_person
      elsif @client_transaction.client.client_company?
        client_type = @client_transaction.client.client_company
      end
      Check.transaction(@client_transaction.credit_value, client_type, @client_transaction)
    else
      # fazer um post atualizando o ecommerce
    end
  end
end
