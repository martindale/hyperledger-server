class Transfer < ActiveRecord::Base
  
  validates_presence_of :source, :destination, :amount
  
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
  
end
