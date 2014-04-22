class AccountSerializer < ActiveModel::Serializer
  attributes :code, :balance, :currency, :public_key
  
  def currency
    object.currency.name
  end
  
end
