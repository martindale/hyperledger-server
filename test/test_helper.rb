ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/mock'
require 'webmock/minitest'

# Setup this node in consensus pool
ENV['POOL_NAME'] = 'test'
ENV['SERVER_NAME'] = 'localtest'
key = OpenSSL::PKey::RSA.new(2048)
ENV['PRIVATE_KEY'] = key.to_pem
ConsensusNode.create!(url: ENV['SERVER_NAME'], public_key: key.public_key.to_pem)

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
end
