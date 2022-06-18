# frozen_string_literal: true

class Api::V1::ClientsController < Api::ApiController
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

  def create
    @client = Client.new(client_params)

    set_client_category_id
    @client.client_category_id = @client_category_id
    @client.save!

    if @client.client_person?
      person_save_render
    elsif @client.client_company?
      company_save_render
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

  def client_params
    params.require(:client).permit(
      :client_type,
      client_person_attributes: %i[full_name cpf client_id],
      client_company_attributes: %i[company_name cnpj client_id]
    )
  end

  def person_save_render
    client_person = ClientPerson.new(client_params[:client_person_attributes])
    client_person.client_id = @client.id
    client_person.save!

    render json: @client,
           include: { client_person: { only: %i[full_name cpf] } },
           except: %i[id created_at updated_at client_category_id],
           status: :created
  end

  def company_save_render
    client_company = ClientCompany.new(client_params[:client_company_attributes])
    client_company.client_id = @client.id
    client_company.save!

    render json: @client,
           include: { client_company: { only: %i[company_name cnpj] } },
           except: %i[id created_at updated_at client_category_id],
           status: :created
  end

  def set_client_category_id
    @client_category_id = ClientCategory.find_or_create_by!(name: 'Padrão', discount_percent: 0).id
  end
end
