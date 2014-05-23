class AddIndices < ActiveRecord::Migration
  def change
    add_index :accounts, :code, unique: true
    add_index :accounts, :public_key, unique: true
    add_index :ledgers, :name, unique: true
    add_index :ledgers, :public_key, unique: true
  end
end
