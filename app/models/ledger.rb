class Ledger < ActiveRecord::Base
  
  has_many    :accounts
  belongs_to  :primary_account, class_name: 'Account'
  has_many    :issues
  
  validates_presence_of :public_key, :name, :url
  validates_uniqueness_of :name
  validate :public_key_must_be_valid
  
  after_create do |ledger|
    acc = Account.create(public_key: ledger.public_key, ledger: ledger)
    ledger.update_attribute :primary_account, acc
  end
  
private
  
  def public_key_must_be_valid
    OpenSSL::PKey::RSA.new(public_key)
  rescue
    errors.add(:public_key, 'is not a valid RSA public key')
  end
  
end
