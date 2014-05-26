ConsensusPool = OpenStruct.new name: ENV['POOL_NAME'],
                               servers: YAML.load(File.open ENV['POOL_CONFIG_PATH'])