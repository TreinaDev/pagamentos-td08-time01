# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name cpf])
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin) && resource.pending?
      sign_out resource
      flash[:alert] = 'Admin pendente'
      root_path
    else
      super
    end
  end
end
