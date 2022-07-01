# frozen_string_literal: true

class ClientTransactionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_client_transaction, only: %i[debt credit]

  def index
    @client_transactions = if params[:filter] == 'all'
                             ClientTransaction.where.not(status: :pending)
                           else
                             ClientTransaction.pending
                           end
  end

  def edit
    @client_transaction = ClientTransaction.find(params[:id])
  end

  def credit
    if params_status == 'approved'
      BuyRubys.perform(@client_transaction.credit_value, @client_transaction.client, @client_transaction)

      redirect_to client_transactions_path, notice: 'A transação foi realizada com sucesso.'
    elsif TransactionNotification.new(client_transaction: @client_transaction, description: set_description).save
      @client_transaction.refused!

      redirect_to client_transactions_path, notice: 'A transação foi recusada com sucesso.'
    else
      redirect_to client_transactions_path, alert: 'Descrição não pode ficar em branco.'
    end
  end

  def debt
    if Check.can_buy_products?(@client_transaction)
      return redirect_to client_transactions_path, alert: @message if need_a_description_to_refuse

      response_status = ecommerce_status

      if response_status == 200
        return redirect_to client_transactions_path, notice: EcommerceResponseMsg.message(response_status)
      end

      return redirect_to client_transactions_path, alert: EcommerceResponseMsg.message(response_status)
    end

    redirect_to client_transactions_path, alert: 'Saldo insuficiente.'
  end

  private

  def set_client_transaction
    @client_transaction = ClientTransaction.find(params[:client_transaction_id])
  end

  def set_description
    params[:transaction_notification]&.values&.last
  end

  def params_status
    params[:status]
  end

  def ecommerce_status
    if params_status == 'approved'
      Check.and_buy(@client_transaction, params_status)
    else
      Check.and_refuse(@client_transaction, params_status, set_description)
    end
  end

  def need_a_description_to_refuse
    @message = 'Descrição não pode ficar em branco.' if params_status == 'refused' && set_description.blank?
  end
end
