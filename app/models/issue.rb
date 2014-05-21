class Issue < ActiveRecord::Base
  
  validates_presence_of :ledger, :amount
  
  belongs_to :ledger
  
  before_create do |issue|
    acc = issue.ledger.primary_account
    acc.update_attribute :balance, (acc.balance + issue.amount)
  end
  
end
