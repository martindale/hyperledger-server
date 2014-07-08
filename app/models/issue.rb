class Issue < ActiveRecord::Base
  include Confirmable
  
  validates_presence_of :ledger, :amount, :client_signature
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
    unless ledger.valid_sig?(client_signature, signable_string)
      errors.add :client_signature, 'is not valid'
    end
  end
  
  def signable_string
    {ledger: ledger.name, amount: amount}.to_json
  end
  
  def broadcast_params
    {issue: {ledger: ledger.name, amount: amount}}
  end
  
end
