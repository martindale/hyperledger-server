class Ledger < ActiveRecord::Base
  
  has_many    :accounts
  belongs_to  :primary_account, class_name: 'Account'
  has_many    :issues
  has_many    :prepare_confirmations, as: :confirmable
  has_many    :commit_confirmations, as: :confirmable
  
  validates_presence_of :public_key, :name, :url
  validates_uniqueness_of :name
  validates :public_key, rsa_public_key: true
  
  def add_prepare(prepare_params)
    quorum = ConsensusPool.instance.quorum
    self.prepare_confirmations.create(prepare_params)
    self.prepared = true if prepare_confirmations.count >= quorum
  end
  
  def add_commit(commit_params)
    quorum = ConsensusPool.instance.quorum
    self.commit_confirmations.create(commit_params)
    self.committed = true if commit_confirmations.count >= quorum
  end
end
