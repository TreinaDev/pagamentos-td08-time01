# frozen_string_literal: true

class ClientTransactionService
  attr_reader :status, :message

  def initialize(client_transaction, description, transaction_status)
    @client_transaction = client_transaction
    @description = description
    @transaction_status = transaction_status
  end

  def perform
    send_transaction_status

    if @transaction_status == 'approved'
      approved_transaction
    else
      refused_transaction
    end
  end

  def send_transaction_status
    @status = TransactionConfirmation.send_response(@client_transaction.code,
                                                    @transaction_status).status

    case @status
    when 404
      @transaction_status = 'pending'

      @message = 'Transação desconhecida pelo ecommerce.'
    when 500
      @transaction_status = 'pending'

      @message = 'Alguma coisa deu errado, por favor contate o suporte do ecommerce'
    end
  end

  def approved_transaction
    if @client_transaction.client.client_person?
      client_type = @client_transaction.client.client_person
    elsif @client_transaction.client.client_company?
      client_type = @client_transaction.client.client_company
    end

    Check.transaction(@client_transaction.credit_value, client_type, @client_transaction)

    @message = 'A transação foi realizada com sucesso.'
  end

  def refused_transaction
    case @status
    when 200
      TransactionNotification.create!(description: @description, client_transaction: @client_transaction)

      @message = 'A transação foi recusada com sucesso.'
    when 422
      @client_transaction.pending!

      @message = 'Tipo de erro em branco'
    end
  end
end
