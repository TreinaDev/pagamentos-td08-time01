class AddClientToClientCompany < ActiveRecord::Migration[7.0]
  def change
    add_reference :client_companies, :client, null: false, foreign_key: true
  end
end
