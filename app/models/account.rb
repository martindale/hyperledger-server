class Account < ActiveRecord::Base
    
  belongs_to :ledger
  
  validates_presence_of :ledger, :public_key
  validates :public_key, uniqueness: true, rsa_public_key: true
  
  before_create do |account|
    digest = Digest::MD5.new.digest(account.public_key)
    account.code = Digest.hexencode(digest)
    account.balance = 0
  end
  
  def add_confirmation
  end
  
end
