class Ledger < ActiveRecord::Base
  include Confirmable
  include Signable
  
  has_many    :accounts
  belongs_to  :primary_account, class_name: 'Account'
  has_many    :issues
  
  validates_presence_of :public_key, :name, :url, :primary_account
  validates_uniqueness_of :name
  validates :public_key, rsa_public_key: true
  
  after_create do |ledger|
    ConsensusNode.broadcast_prepare(:ledger, broadcast_params)
  end
  
  def broadcast_params
    { ledger: attributes.slice(:public_key, :name, :url),
      primary_account: { public_key: primary_account.public_key }}
  end
  
end
