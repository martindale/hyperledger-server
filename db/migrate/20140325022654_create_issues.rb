class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :currency_id
      t.integer :amount

      t.timestamps
    end
  end
end
