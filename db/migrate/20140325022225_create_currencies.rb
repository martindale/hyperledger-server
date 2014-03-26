class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.text :public_key
      t.string :name
      t.string :url
      t.integer :primary_account_id

      t.timestamps
    end
  end
end
