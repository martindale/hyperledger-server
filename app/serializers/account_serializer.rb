class AccountSerializer < ActiveModel::Serializer
  attributes :code, :balance, :ledger, :public_key, :prepared, :committed
  has_many :prepare_confirmations
  has_many :commit_confirmations
  
  def ledger
    object.ledger.name
  end
  
end
