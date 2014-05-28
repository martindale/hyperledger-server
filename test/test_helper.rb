ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/mock'
require 'webmock/minitest'

ENV['POOL_NAME'] = 'Test'
ENV['POOL_CONFIG_PATH'] = (Rails.root + 'test/pool.yml').to_s
ENV['SERVER_NAME'] = 'test'
ENV['PRIVATE_KEY'] = OpenSSL::PKey::RSA.new(2048).to_pem

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
end
