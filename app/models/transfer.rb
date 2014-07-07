class Transfer < ActiveRecord::Base
  include Confirmable
  
  validates_presence_of :source, :destination, :amount, :client_signature
  validate :valid_signature, :same_ledger, :sufficient_balance
  
  belongs_to :source, class_name: 'Account'
  belongs_to :destination, class_name: 'Account'
  
  after_create do |transfer|
    transaction do
      source.lock!
      destination.lock!
      
      source.balance -= transfer.amount
      destination.balance += transfer.amount
      
      source.save!
      destination.save!
    end
  end
  
  def valid_signature
    unless source.valid_sig?(client_signature, signable_string)
      errors.add :client_signature, 'is not valid'
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
  
end
