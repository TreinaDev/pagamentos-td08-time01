# frozen_string_literal: true

module Api
  module V1
    class ClientPeopleController < ActionController::API
      def create
        client_person = ClientPerson.new(client_person_params)

        if client_person.save
          render json: client_person, status: :created
        else
          render status: :precondition_failed, json: { errors: client_person.errors.full_messages }
        end
      end

      private

      def client_person_params
        params.require(:client_person).permit(:full_name, :cpf, :client_id)
      end
    end
  end
end
