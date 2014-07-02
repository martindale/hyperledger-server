class Transfer < ActiveRecord::Base
  include Confirmable
  
  validates_presence_of :source, :destination, :amount
  validate :sufficient_balance
  
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
  
private
  
  def sufficient_balance
    if amount > source.balance
      errors.add :amount, 'is greater than the available balance'
    end
  end
  
end
