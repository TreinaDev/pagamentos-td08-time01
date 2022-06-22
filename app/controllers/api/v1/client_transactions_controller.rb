# frozen_string_literal: true

class Api::V1::ClientTransactionsController < Api::ApiController
  def create
    if params[:cpf].present?
      TransactionPerson.perform(params[:cpf], client_transaction_params)

      return render json: {}, status: :created
    elsif params[:cnpj].present?
      TransactionCompany.perform(params[:cnpj], client_transaction_params)

      return render json: {}, status: :created
    end

    render json: {}, status: :bad_request
  end

  private

  def client_transaction_params
    params.require(:client_transaction).permit(:credit_value, :type_transaction)
  end
end
