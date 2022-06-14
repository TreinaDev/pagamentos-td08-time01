# frozen_string_literal: true

class CreateClientCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :client_companies do |t|
      t.string :company_name
      t.string :cnpj

      t.timestamps
    end
  end
end
