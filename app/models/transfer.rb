class Transfer < ActiveRecord::Base
  include Confirmable
  
  validates_presence_of :source, :destination, :amount, :resource_signature
  validate :valid_signature, :same_ledger, :sufficient_balance
  
  belongs_to :source, class_name: 'Account'
  belongs_to :destination, class_name: 'Account'
  
  def after_commit
    transaction do
      source.lock!
      destination.lock!
      
      source.balance -= amount
      destination.balance += amount
      
      source.save!
      destination.save!
    end
  end
  
private
  
  def valid_signature
    unless source.valid_sig?(resource_signature, signable_string)
      errors.add :resource_signature, 'is not valid'
    end
  end
  
  def signable_string
    {source: source.code, destination: destination.code, amount: amount}.to_json
  end
  
  def same_ledger
    if source.ledger != destination.ledger
      errors.add :ledger, 'is not the same for both accounts'
    end
  end
  
  def sufficient_balance
    if amount > source.balance
      errors.add :amount, 'is greater than the available balance'
    end
  end
  
  def broadcast_params
    {transfer: {source: source.code, destination: destination.code,
                amount: amount, resource_signature: resource_signature}}
  end
  
end
