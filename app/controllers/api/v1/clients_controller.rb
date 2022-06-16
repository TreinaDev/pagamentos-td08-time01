# frozen_string_literal: true

module Api
  module V1
    class ClientsController < ActionController::API
      def show
        client = Client.find(params[:id])
        render json: client
      rescue StandardError
        render json: { errors: 'Cliente não encontrado' }, status: :not_found
      end
    end
  end
end
