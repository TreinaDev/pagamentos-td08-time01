# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin', type: :request do
  describe 'POST /admin_permissions' do
    it 'when an unauthorized user force a POST' do
      pendent_adm = create(:admin, status: 0)

      post admin_permissions_path, params: { admin_permission: { pending_admin: pendent_adm.id } }

      expect(response).to redirect_to new_admin_session_path
    end

    it 'when a pending admin force a POST' do
      forcing_post_admin = create(:admin, status: 0)
      pendent_adm = create(:admin, status: 0)

      login_as forcing_post_admin
      post admin_permissions_path, params: { admin_permission: { pending_admin: pendent_adm.id } }

      expect(response).to redirect_to root_path
      expect(flash.alert).to eq 'Apenas administradores ativos tem a permissão de aceitar um usuario pendente'
    end
  end
end
