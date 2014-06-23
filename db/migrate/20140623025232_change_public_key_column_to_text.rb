class ChangePublicKeyColumnToText < ActiveRecord::Migration
  def up
    change_column :consensus_nodes, :public_key, :text
  end
  
  def down
    change_column :consensus_nodes, :public_key, :string
  end
end
