class LedgerSerializer < ActiveModel::Serializer
  attributes :name, :public_key, :url, :prepared, :committed
  has_one :primary_account
  has_many :prepare_confirmations
  has_many :commit_confirmations
end
