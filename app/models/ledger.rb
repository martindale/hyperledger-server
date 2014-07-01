class Ledger < ActiveRecord::Base
  
  has_many    :accounts
  belongs_to  :primary_account, class_name: 'Account'
  has_many    :issues
  has_many    :prepare_confirmations, as: :confirmable
  
  validates_presence_of :public_key, :name, :url
  validates_uniqueness_of :name
  validates :public_key, rsa_public_key: true
  
  def add_confirmation
    self.with_lock do
      self.confirmation_count += 1
      self.confirmed = true if self.confirmation_count >= ConsensusPool.instance.quorum
      self.save
    end
  end
  
end
