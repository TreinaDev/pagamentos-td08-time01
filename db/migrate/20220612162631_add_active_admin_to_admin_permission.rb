class AddActiveAdminToAdminPermission < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_permissions, :active_admin, :integer
  end
end
