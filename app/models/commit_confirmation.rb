class CommitConfirmation < ActiveRecord::Base
  belongs_to :confirmable, polymorphic: true
  validates_presence_of :node, :signature, :confirmable
end
