class Issue < ActiveRecord::Base
  
  validates_presence_of :currency_id, :amount
  
  belongs_to :currency
  
  before_create do |issue|
    acc = issue.currency.primary_account
    acc.update_attribute :balance, (acc.balance + issue.amount)
  end
  
end
