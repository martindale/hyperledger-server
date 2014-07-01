class CreatePrepareConfirmations < ActiveRecord::Migration
  def change
    create_table :prepare_confirmations do |t|
      t.string :node
      t.text :signature
      t.references :confirmable, polymorphic: true

      t.timestamps
    end
    
    add_index :prepare_confirmations, [:confirmable_id, :confirmable_type], name: :index_prepare_polymorphic_reference
  end
end
