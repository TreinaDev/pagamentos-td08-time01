# frozen_string_literal: true

class ClientTransactionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_client_transaction, only: %i[edit update]

  def index
    @client_transactions = if params[:filter] == 'all'
                             ClientTransaction.where.not(status: :pending)
                           else
                             ClientTransaction.pending
                           end
  end

  def edit; end

  def update
    if params_status == 'approved' && @client_transaction.buy_rubys?
      BuyRubys.perform(@client_transaction.credit_value, @client_transaction.client, @client_transaction)

      return redirect_to client_transactions_path, notice: 'A transação foi realizada com sucesso.'
    elsif params_status == 'refused' && @client_transaction.buy_rubys?
      notification = TransactionNotification.new(client_transaction: @client_transaction, description: set_description)

      if notification.save
        @client_transaction.refused!

        return redirect_to client_transactions_path, notice: 'A transação foi recusada com sucesso.'
      else
        flash.now[:alert] = 'Descrição não pode ficar em branco.'

        return render :edit
      end
    end

    unless Check.can_buy_products?(@client_transaction)

      return redirect_to client_transactions_path, alert: 'Saldo insuficiente.'
    end

    redirect_to client_transactions_path, alert: EcommerceResponseMsg.message(ecommerce_status)
  end

  private

  def set_client_transaction
    @client_transaction = ClientTransaction.find(params[:id])
  end

  def set_description
    params[:client_transaction][:transaction_notification]&.values&.last
  end

  def params_status
    params[:client_transaction][:status]
  end

  def ecommerce_status
    if params_status == 'approved'
      Check.and_buy(@client_transaction, params_status)
    else
      Check.and_refuse(@client_transaction, params_status, set_description)
    end
  end
end
