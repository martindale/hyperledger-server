class Issue < ActiveRecord::Base
  include Confirmable
  
  validates_presence_of :ledger, :amount, :resource_signature
  validate :valid_signature
  
  belongs_to :ledger
  
  def after_commit
    account = ledger.primary_account
    transaction do
      account.lock!
      account.balance += amount
      account.save!
    end
  end
  
private
  
  def valid_signature
    unless ledger.valid_sig?(resource_signature, signable_string)
      errors.add :resource_signature, 'is not valid'
    end
  end
  
  def signable_string
    {ledger: ledger.name, amount: amount}.to_json
  end
  
  def broadcast_params
    {issue: {ledger: attributes.slice('name', 'amount', 'resource_signature')}}
  end
  
end
