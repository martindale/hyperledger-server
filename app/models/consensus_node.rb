class ConsensusNode < ActiveRecord::Base
  include Signable
  
  validates_presence_of :url, :public_key
  validates_uniqueness_of :url
  
  def self.quorum
    max_failures = ((count - 1) / 3.0).floor
    count - max_failures
  end
  
  def self.broadcast(resource, data)
    key = OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'].gsub('\n',"\n"))
    signature = (Base64.encode64 key.sign(OpenSSL::Digest::SHA256.new, data.to_json))
    auth = {node: ENV['NODE_URL'], signature: signature}
    broadcast_urls.each do |url|
      RestClient.post "#{url}/#{resource.to_s.pluralize}",
                      data.merge({ authentication: auth }),
                      content_type: :json,
                      accept: :json
    end
  end
  
private
  
  def self.broadcast_urls
    where('url != ?', ENV['NODE_URL']).map(&:url)
  end
  
end
