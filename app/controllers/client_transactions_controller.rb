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

      transaction_notification = TransactionNotification.create!(description: description, client_transaction: @client_transaction)
      response = TransactionConfirmation.send_response(@client_transaction.code, @client_transaction.status, transaction_notification.description)
      if response.status == 422
        @client_transaction.pending!
        return redirect_to client_transactions_path, alert: 'Tipo de erro em branco'
      elsif response.status == 200
        return redirect_to client_transactions_path, notice: 'A transação foi recusada com sucesso.'
      end  
    end

    set_client_type
    response = TransactionConfirmation.send_response(@client_transaction.code, @client_transaction.status)

    if response.status == 404
      @client_transaction.pending!
      return redirect_to client_transactions_path, alert: 'Transação desconhecida pelo ecommerce.'
    elsif response.status == 500
      @client_transaction.pending!
      return redirect_to client_transactions_path, alert: 'Alguma coisa deu errado, por favor contate o suporte do ecommerce'
    end

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
    end
  end
end
