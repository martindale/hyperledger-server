class ConsensusPool
  include Singleton
  
  attr_reader :name, :servers, :quorum
  
  def initialize
    @name = ENV['POOL_NAME']
    @servers = ConsensusNode.all
    max_failures = ((servers.count - 1) / 3.0).floor
    @quorum = @servers.count - max_failures
  end
  
  def valid_confirmation?(server_id, signature, data)
    confirmation_server = servers.find { |s| s[:url] == server_id }
    return false unless confirmation_server
    
    key = OpenSSL::PKey::RSA.new(confirmation_server[:public_key])
    key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), data.to_json)
  end
  
  def broadcast(resource, data)
    key = OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'].gsub('\n',"\n"))
    signature = (Base64.encode64 key.sign(OpenSSL::Digest::SHA256.new, data.to_json))
    confirmation = {server: ENV['SERVER_NAME'], signature: signature}
    broadcast_urls = servers.map { |s| s[:url] }.reject { |url| url == ENV['SERVER_NAME']}
    broadcast_urls.each do |url|
      RestClient.post "#{url}/#{resource.to_s.pluralize}",
                      data.merge({ confirmation: confirmation }),
                      content_type: :json,
                      accept: :json
    end
  end
  
end
