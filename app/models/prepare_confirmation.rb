class PrepareConfirmation < ActiveRecord::Base
  belongs_to :confirmable, polymorphic: true
  validates_presence_of :node, :confirmable
  
  scope :signed, -> { where('signature IS NOT ?', nil) }
end
