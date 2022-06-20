class CreateClientBalanceBonus < ActiveRecord::Migration[7.0]
  def change
    create_table :client_bonus_balances do |t|
      t.float :bonus_value, default: 0
      t.date :expire_date
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
