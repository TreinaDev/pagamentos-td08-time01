# frozen_string_literal: true

class Api::V1::ClientPeopleController < Api::ApiController
  def create
    client_person = ClientPerson.create!(client_person_params)

    render json: client_person, status: :created
  end

  private

  def client_person_params
    params.require(:client_person).permit(:full_name, :cpf, :client_id)
  end
end
