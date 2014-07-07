class AddClientSignaturesToIssuesAndTransfers < ActiveRecord::Migration
  def change
    add_column :issues, :client_signature, :text
    add_column :transfers, :client_signature, :text
  end
end
