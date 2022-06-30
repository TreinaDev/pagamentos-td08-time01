# frozen_string_literal: true

class Api::V1::ClientTransactionsController < Api::ApiController
  def create
    return render plain: exchange_error_msg, status: :not_implemented unless CheckExchangeRateValid.perform

    register_transaction
  end

  private

  def client_transaction_params
    params.require(:client_transaction).permit(:credit_value, :type_transaction)
  end

  def register_transaction
    if params[:cpf].present?
      render json: TransactionPerson.perform(params[:cpf], client_transaction_params),
             only: %i[code], status: :created
    elsif params[:cnpj].present?
      render json: TransactionCompany.perform(params[:cnpj], client_transaction_params),
             only: %i[code], status: :created
    else
      render json: { message: 'A validação falhou: sintaxe inválida' }, status: :bad_request
    end
  end

  def exchange_error_msg
    'Não existe uma taxa de câmbio válida, por favor contate a API de pagamento.'
  end
end
