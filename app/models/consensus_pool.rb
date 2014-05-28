class ConsensusPool
  include Singleton
  
  attr_reader :name, :servers, :quorum
  
  def initialize
    @name = ENV['POOL_NAME']
    @servers = YAML.load File.open ENV['POOL_CONFIG_PATH']
    max_failures = ((servers.count - 1) / 3.0).floor
    @quorum = @servers.count - max_failures
  end
  
  def valid_confirmation?(confirmation, data)
  end
end
