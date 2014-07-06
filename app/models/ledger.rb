class Ledger < ActiveRecord::Base
  include Confirmable
  
  has_many    :accounts
  belongs_to  :primary_account, class_name: 'Account'
  has_many    :issues
  
  validates_presence_of :public_key, :name, :url
  validates_uniqueness_of :name
  validates :public_key, rsa_public_key: true
  
  after_create do |ledger|
    params = LedgerSerializer.new(ledger).as_json
    ConsensusNode.broadcast(:ledger, params)
  end
end
