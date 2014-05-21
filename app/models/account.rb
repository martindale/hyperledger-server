class Account < ActiveRecord::Base
    
  belongs_to :ledger
  
  validates_presence_of :ledger, :public_key
  
  validates_uniqueness_of :public_key
  
  before_create do |account|
    digest = Digest::MD5.new.digest(account.public_key)
    account.code = Digest.hexencode(digest)
    account.balance = 0
  end
  
end
