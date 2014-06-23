class CreateConsensusNodes < ActiveRecord::Migration
  def change
    create_table :consensus_nodes do |t|
      t.string :url
      t.string :public_key

      t.timestamps
    end
  end
end
