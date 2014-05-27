class AddConfirmationCountToAllTables < ActiveRecord::Migration
  def change
    [:ledgers, :accounts, :issues, :transfers].each do |t|
      add_column t, :confirmation_count, :integer, default: 0
      add_column t, :confirmed, :boolean, default: false
    end
  end
end
