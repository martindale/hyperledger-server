class Currency < ActiveRecord::Base
  
  has_many    :accounts
  belongs_to  :primary_account, class_name: 'Account'
  
  validates_presence_of :public_key, :name, :url
  
  validates_uniqueness_of :name
  
  after_create do |currency|
    acc = Account.create(public_key: currency.public_key, currency: currency)
    currency.update_attribute :primary_account, acc
  end
    
  def as_json(options)
    super(only: [:name, :public_key, :url])
  end
  
end
