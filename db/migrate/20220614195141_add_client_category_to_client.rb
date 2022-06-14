class AddClientCategoryToClient < ActiveRecord::Migration[7.0]
  def change
    add_reference :clients, :client_category, null: false, foreign_key: true
  end
end
