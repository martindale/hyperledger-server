class Issue < ActiveRecord::Base
  include Confirmable
  
  validates_presence_of :ledger, :amount
  
  belongs_to :ledger
  
  before_create do |issue|
    account = issue.ledger.primary_account
    transaction do
      account.lock!
      account.balance += issue.amount
      account.save!
    end
  end
  
end
