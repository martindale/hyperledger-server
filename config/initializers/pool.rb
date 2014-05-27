servers = YAML.load File.open ENV['POOL_CONFIG_PATH']
quorum = ((servers.count - 1) / 3.0).ceil

ConsensusPool = OpenStruct.new name: ENV['POOL_NAME'],
                               servers: servers,
                               quorum: quorum