class AddIndexUniqueToTables < ActiveRecord::Migration[7.0]
  def change
    add_index :client_categories, :name, unique: true
    add_index :client_people, :cpf, unique: true
    add_index :client_companies, :cnpj, unique: true
  end
end
