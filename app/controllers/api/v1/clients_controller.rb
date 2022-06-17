    # frozen_string_literal: true

module Api
  module V1
    class ClientsController < ActionController::API
      def show
        registration_number = params[:registration_number]
        if CPF.valid?(registration_number, strict: true)
          render_client_person(registration_number)
        elsif CNPJ.valid?(registration_number, strict: true)
          render_client_company(registration_number)
        else
          render json: { errors: 'Cliente não encontrado' }, status: :not_found
        end
      end

      private

      def render_client_person(cpf)
        client_person = ClientPerson.find_by(cpf: cpf)
        client = client_person.client
        client_category = client.client_category
        render json: [client.as_json(except: %i[created_at updated_at client_category_id id client_type]),
                      client_category.as_json(except: %i[created_at updated_at id]),
                      client_person.as_json(except: %i[created_at updated_at client_id id])]
      end

      def render_client_company(cnpj)
        client_company = ClientCompany.find_by(cnpj: cnpj)
        client = client_company.client
        client_category = client.client_category
        render json: [client.as_json(except: %i[created_at updated_at client_category_id id client_type]),
                      client_category.as_json(except: %i[created_at updated_at id]),
                      client_company.as_json(except: %i[created_at updated_at client_id id])]
      end
    end
  end
end
