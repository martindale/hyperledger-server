module Signable
  extend ActiveSupport::Concern
  
  def valid_sig?(signature, data)
    key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), data)
  end
  
  def key
    OpenSSL::PKey::RSA.new(public_key)
  end
  
end
