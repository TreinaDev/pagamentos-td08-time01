# frozen_string_literal: true

class Api::V1::ClientTransactionsController < Api::ApiController
  def create
    if params[:cpf].present?
      render json: TransactionPerson.perform(params[:cpf], client_transaction_params),
             except: %i[id created_at updated_at client_id approval_date],
             status: :created

    elsif params[:cnpj].present?
      render json: TransactionCompany.perform(params[:cnpj], client_transaction_params),
             except: %i[id created_at updated_at client_id approval_date],
             status: :created
    end
  end

  private

  def client_transaction_params
    params.require(:client_transaction).permit(:credit_value, :type_transaction)
  end
end
