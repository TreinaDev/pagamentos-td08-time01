# frozen_string_literal: true

class Api::V1::ClientsController < Api::ApiController
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
