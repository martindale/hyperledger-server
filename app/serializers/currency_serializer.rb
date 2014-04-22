class CurrencySerializer < ActiveModel::Serializer
  attributes :name, :public_key, :url
  has_one :primary_account
end
