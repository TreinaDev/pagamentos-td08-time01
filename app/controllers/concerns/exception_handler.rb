# frozen_string_literal: false

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::ActiveRecordError do |error|
      render json: { message: error.message }, status: :internal_server_error
    end

    rescue_from ActionController::ParameterMissing do |_error|
      render json: { message: 'A validação falhou: sintaxe inválida' }, status: :bad_request
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      render json: { message: error.message }, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotFound do |error|
      render json: { message: "Não foi possível encontrar #{I18n.t(error.model)} com os dados informados" },
             status: :not_found
    end
  end
end
