require 'test_helper'

class ConsensusPoolTest < ActiveSupport::TestCase
  
  setup do
    @key = OpenSSL::PKey::RSA.new(2048)
    @mock_server = { url: 'test', public_key: @key.public_key.to_pem }
  end
  
  test 'the consensus pool is initialised' do
    assert_equal 'Test', ConsensusPool.instance.name
  end
  
  test '#valid_confirmation? returns true for valid signature' do
    sign = Base64.encode64 @key.sign(OpenSSL::Digest::SHA256.new, {test: 'test'}.to_json)
    ConsensusPool.instance.stub :servers, [@mock_server] do
      assert ConsensusPool.instance.valid_confirmation?('test', sign, {test: 'test'})
    end
  end
  
  test '#valid_confirmation? returns false for invalid signature' do
    key2 = OpenSSL::PKey::RSA.new(2048)
    bad_sign = Base64.encode64 key2.sign(OpenSSL::Digest::SHA256.new, {test: 'test'}.to_json)
    ConsensusPool.instance.stub :servers, [@mock_server] do
      refute ConsensusPool.instance.valid_confirmation?('test', bad_sign, {test: 'test'})
    end
  end
  
end