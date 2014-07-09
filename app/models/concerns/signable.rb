module Signable
  extend ActiveSupport::Concern
  
  def valid_sig?(signature, data)
    result = key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), data)
    OpenSSL.errors # Weird OpenSSL bug
    result
  rescue
    false
  end
  
  def key
    OpenSSL::PKey::RSA.new(public_key)
  end
  
end
