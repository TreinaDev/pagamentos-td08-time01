class CreateClientPeople < ActiveRecord::Migration[7.0]
  def change
    create_table :client_people do |t|
      t.string :full_name
      t.string :cpf

      t.timestamps
    end
  end
end
