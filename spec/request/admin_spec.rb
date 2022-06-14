# frozen_string_literal: true

RSpec.describe 'Admin', type: :request do
  describe 'POST /admin_permissions' do
    it 'when an unauthorized user force a POST' do
      pendent_adm = create(:admin, status: 0)

      post admin_permissions_path, params: { admin_permission: { pending_admin: pendent_adm.id } }

      debugger
      expect(response)
    end
  end
end
