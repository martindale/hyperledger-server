class Ledger < ActiveRecord::Base
  
  has_many    :accounts
  belongs_to  :primary_account, class_name: 'Account'
  has_many    :issues
  
  validates_presence_of :public_key, :name, :url
  validates_uniqueness_of :name
  validates :public_key, rsa_public_key: true
  
  after_create do |ledger|
    acc = Account.create(public_key: ledger.public_key, ledger: ledger)
    ledger.update_attribute :primary_account, acc
  end
  
end
