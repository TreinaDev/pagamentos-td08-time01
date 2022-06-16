# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::ActiveRecordError do |error|
      render json: { message: error.message }, status: :internal_server_error
    end

    rescue_from ActiveRecord::RecordNotFound do |error|
      render json: { message: error.message }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |error|
      render json: { message: error.message }, status: :bad_request
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      render json: { message: error.message }, status: :unprocessable_entity
    end
  end
end
