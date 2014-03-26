class Transfer < ActiveRecord::Base
  
  validates_presence_of :source_id, :destination_id, :amount
  
  belongs_to :source, class_name: 'Account'
  belongs_to :destination, class_name: 'Account'
  
  before_create do |transfer|
    source.update_attribute :balance, (source.balance - transfer.amount)
    destination.update_attribute :balance, (destination.balance + transfer.amount)
  end
  
end
