class Ledger < ActiveRecord::Base
  include Confirmable
  
  has_many    :accounts
  belongs_to  :primary_account, class_name: 'Account'
  has_many    :issues
  has_many    :prepare_confirmations, as: :confirmable
  has_many    :commit_confirmations, as: :confirmable
  
  validates_presence_of :public_key, :name, :url
  validates_uniqueness_of :name
  validates :public_key, rsa_public_key: true
  
end
