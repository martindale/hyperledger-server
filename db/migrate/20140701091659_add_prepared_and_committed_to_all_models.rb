class AddPreparedAndCommittedToAllModels < ActiveRecord::Migration
  def change
    [:ledgers, :accounts, :issues, :transfers].each do |t|
      remove_column t, :confirmed
      remove_column t, :confirmation_count
      add_column t, :prepared, :boolean, default: false
      add_column t, :committed, :boolean, default: false
    end
  end
end
