class AccountSerializer < ActiveModel::Serializer
  attributes :code, :balance, :ledger, :public_key
  
  def ledger
    object.ledger.name
  end
  
end
