# frozen_string_literal: true

class AdminPermissionsController < ApplicationController
  before_action :authenticate_admin!

  def create
    @admin_permission = AdminPermission.create!(admin_id: params[:pending_admin], active_admin: current_admin.id)
    accept_admin

    redirect_to pendencies_path, notice: 'Permissão concedida a um administrador pendente'
  end

  private

  def accept_admin
    admin_permissions = AdminPermission.where(admin_id: params[:pending_admin])

    return Admin.find(@admin_permission.admin_id).active! if admin_permissions.count == 2
  end
end
