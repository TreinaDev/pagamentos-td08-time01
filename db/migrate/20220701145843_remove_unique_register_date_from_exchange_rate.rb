class RemoveUniqueRegisterDateFromExchangeRate < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        remove_index :exchange_rates, :register_date
        add_index :exchange_rates, :register_date
      end

      dir.down do
        remove_index :exchange_rates, :register_date
        add_index :exchange_rates, :register_date, unique: true
      end
    end
  end
end
