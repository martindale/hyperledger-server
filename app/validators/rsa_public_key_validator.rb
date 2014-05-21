class RsaPublicKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    OpenSSL::PKey::RSA.new(value)
  rescue
    record.errors[attribute] << (options[:message] || 'is not a valid RSA public key')
  end
end