class RenameCurrenciesToLedgers < ActiveRecord::Migration
  def change
    rename_table :currencies, :ledgers
    rename_column :accounts, :currency_id, :ledger_id
    rename_column :issues, :currency_id, :ledger_id
  end
end
