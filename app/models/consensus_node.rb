class ConsensusNode < ActiveRecord::Base
  include Signable
  
  validates_presence_of :url, :public_key
  validates_uniqueness_of :url
  
  def self.quorum
    max_failures = ((count - 1) / 3.0).floor
    count - max_failures
  end
  
  def self.broadcast_prepare(resource, data)
    broadcast_urls.each do |url|
      RestClient.post "#{url}/#{resource.to_s.pluralize}/prepare",
                      data.merge({ authentication: auth_params(data) }),
                      content_type: :json,
                      accept: :json
    end
  end
  
  def self.broadcast_commit(resource, data)
    data.merge!(commit: true)
    broadcast_urls.each do |url|
      RestClient.post "#{url}/#{resource.to_s.pluralize}/commit",
                      data.merge({ authentication: auth_params(data) }),
                      content_type: :json,
                      accept: :json
    end
  end
  
private
  
  def self.auth_params(data)
    key = OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'].gsub('\n',"\n"))
    signature = (Base64.encode64 key.sign(OpenSSL::Digest::SHA256.new, data.to_json))
    {node: ENV['NODE_URL'], signature: signature}
  end
  
  def self.broadcast_urls
    where('url != ?', ENV['NODE_URL']).map(&:url)
  end
  
end
