class ConsensusPool
  include Singleton
  
  attr_reader :name, :servers, :quorum
  
  def initialize
    @name = ENV['POOL_NAME']
    @servers = YAML.load File.open ENV['POOL_CONFIG_PATH']
    max_failures = ((servers.count - 1) / 3.0).floor
    @quorum = @servers.count - max_failures
  end
  
  def valid_confirmation?(server_id, signature, data)
    confirmation_server = servers.find { |s| s[:url] == server_id }
    return false unless confirmation_server
    
    key = OpenSSL::PKey::RSA.new(confirmation_server[:public_key])
    key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), data.to_json)
  end
end
