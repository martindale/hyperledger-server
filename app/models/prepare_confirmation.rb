class PrepareConfirmation < ActiveRecord::Base
  belongs_to :confirmable, polymorphic: true
end
