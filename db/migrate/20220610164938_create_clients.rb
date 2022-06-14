class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :client_type

      t.timestamps
    end
  end
end
