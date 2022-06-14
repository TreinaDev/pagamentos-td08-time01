# frozen_string_literal: true

module Api
  module V1
    class ClientCompaniesController < ActionController::API
      def create
        client_company = ClientCompany.new(client_company_params)

        if client_company.save
          render json: client_company, status: :created
        else
          render status: :precondition_failed, json: { errors: client_company.errors.full_messages }
        end
      end

      private

      def client_company_params
        params.require(:client_company).permit(:company_name, :cnpj)
      end
    end
  end
end
