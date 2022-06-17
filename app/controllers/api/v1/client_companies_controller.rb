# frozen_string_literal: true

class Api::V1::ClientCompaniesController < Api::ApiController
  def create
    client_company = ClientCompany.create!(client_company_params)

    render json: client_company, status: :created
  end

  private

  def client_company_params
    params.require(:client_company).permit(:company_name, :cnpj, :client_id)
  end
end
