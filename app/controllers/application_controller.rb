# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name cpf])
  end

  def after_sign_in_path_for(resource)
    return super unless resource.is_a?(Admin) && resource.pending?

    sign_out resource

    flash.clear
    flash[:alert] = 'Apenas administradores ativos tem a permissão de acessar a aplicação de pagamentos'

    root_path
  end
end
