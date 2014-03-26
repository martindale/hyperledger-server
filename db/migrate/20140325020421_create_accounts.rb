class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :code
      t.text :public_key
      t.integer :currency_id
      t.integer :balance

      t.timestamps
    end
  end
end
