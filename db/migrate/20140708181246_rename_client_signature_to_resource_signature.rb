class RenameClientSignatureToResourceSignature < ActiveRecord::Migration
  def change
    rename_column :issues, :client_signature, :resource_signature
    rename_column :transfers, :client_signature, :resource_signature
  end
end
