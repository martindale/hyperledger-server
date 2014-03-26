class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :amount
      t.integer :source_id
      t.integer :destination_id

      t.timestamps
    end
  end
end
