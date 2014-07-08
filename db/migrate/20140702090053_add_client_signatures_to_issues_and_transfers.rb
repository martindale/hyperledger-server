class AddClientSignaturesToIssuesAndTransfers < ActiveRecord::Migration
  def change
    add_column :issues, :resource_signature, :text
    add_column :transfers, :resource_signature, :text
  end
end
