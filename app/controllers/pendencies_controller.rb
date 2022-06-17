# frozen_string_literal: true

class PendenciesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @pending_admins = []
    filter
  end

  private

  def filter
    Admin.pending.each do |pending_admin|
      if pending_admin.admin_permissions.blank? || pending_admin.admin_permissions[0].active_admin != current_admin.id
        @pending_admins << pending_admin
      end
    end
  end
end
