# frozen_string_literal: true

class Api::V1::ClientsController < ActionController::API
  def info
    registration_number = params[:registration_number]
    if CPF.valid?(registration_number, strict: true)
      render_client_person(CPF.new(registration_number).formatted)
    elsif CNPJ.valid?(registration_number, strict: true)
      render_client_company(registration_number)
    else
      render json: { errors: 'Cliente não encontrado' }, status: :not_found
    end
  end

  private

  def render_client_person(cpf)
    client_person = ClientPerson.find_by(cpf:)
    client = client_person.client
    client_category = client.client_category
    render json: [client.as_json(except: %i[created_at updated_at client_category_id id client_type]),
                  client_category.as_json(except: %i[created_at updated_at id]),
                  client_person.as_json(except: %i[created_at updated_at client_id id])]
  end

  def render_client_company(cnpj)
    client_company = ClientCompany.find_by(cnpj:)
    client = client_company.client
    client_category = client.client_category
    render json: [client.as_json(except: %i[created_at updated_at client_category_id id client_type]),
                  client_category.as_json(except: %i[created_at updated_at id]),
                  client_company.as_json(except: %i[created_at updated_at client_id id])]
  end
end
