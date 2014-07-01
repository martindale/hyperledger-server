class CreateCommitConfirmations < ActiveRecord::Migration
  def change
    create_table :commit_confirmations do |t|
      t.string :node
      t.text :signature
      t.references :confirmable, polymorphic: true
      
      t.timestamps
    end
    
    add_index :commit_confirmations, [:confirmable_id, :confirmable_type], name: :index_commit_polymorphic_reference
  end
end
