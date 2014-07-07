ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/mock'
require 'webmock/minitest'

# Setup this node in consensus pool
ENV['NODE_URL'] = 'localtest'
key ||= OpenSSL::PKey::RSA.new(2048)
ENV['PRIVATE_KEY'] = key.to_pem
ConsensusNode.create(url: ENV['NODE_URL'], public_key: key.public_key.to_pem)

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_basic_ledger(name, public_key)
    name ||= 'Moonbucks'
    public_key ||= OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    ledger = Ledger.new(public_key: public_key, name: name, url: 'http://moonbucks.com')
    ledger.primary_account = ledger.accounts.build(public_key: public_key)
    ledger.save!
    ledger
  end
end
