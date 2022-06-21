# frozen_string_literal: true

class ClientTransactionsController < ApplicationController
  before_action :set_client_transaction, only: %i[edit update]

  def index
    @client_transactions = ClientTransaction.where(status: :pending)
  end

  def edit
    return if @client_transaction.pending?

    redirect_to client_transactions_path, notice: 'A transação não pode ser alterada.'
  end

  def update
    @client_transaction.update!(status: params[:client_transaction][:status])

    redirect_to client_transactions_path,
                notice: 'A transação foi alterada com sucesso.'
  end

  private

  def set_client_transaction
    @client_transaction = ClientTransaction.find(params[:id])
  end
end
