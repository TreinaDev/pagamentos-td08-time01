# frozen_string_literal: true

module Api
  module V1
    class ClientsController < ActionController::API
      def show
        client = Client.find(params[:id])
        render json: [client.as_json(except: %i[created_at updated_at client_category_id id client_type]),
                      client.client_category.as_json(except: %i[created_at updated_at id]),
                      client.client_people.as_json(except: %i[created_at updated_at client_id id])]
      rescue StandardError
        render json: { errors: 'Cliente não encontrado' }, status: :not_found
      end
    end
  end
end
