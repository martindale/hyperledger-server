require 'test_helper'

class ConsensusNodeTest < ActiveSupport::TestCase
  
  setup do
    @key = OpenSSL::PKey::RSA.new(2048)
    ConsensusNode.create!(url: 'test', public_key: @key.public_key.to_pem)
  end
  
  test '#valid_confirmation? returns true for valid signature' do
    sign = Base64.encode64 @key.sign(OpenSSL::Digest::SHA256.new, {test: 'test'}.to_json)
    assert ConsensusNode.find_by_url('test').valid_confirmation?(sign, test: 'test')
  end
  
  test '#valid_confirmation? returns false for invalid signature' do
    key2 = OpenSSL::PKey::RSA.new(2048)
    bad_sign = Base64.encode64 key2.sign(OpenSSL::Digest::SHA256.new, {test: 'test'}.to_json)
    refute ConsensusNode.find_by_url('test').valid_confirmation?(bad_sign, test: 'test')
  end
  
  test '.broadcast sends a post to all other nodes' do
    data = {test: 'test'}
    stub_request(:post, 'test/ledgers')
    ConsensusNode.broadcast(:ledger, data)
    assert_requested(:post, 'test/ledgers', times: 1)
  end
  
  test '.quorum returns an int > 2/3 of node count - e.g. 3 for 3' do
    ConsensusNode.stub :count, 3 do
      assert_equal 3, ConsensusNode.quorum
    end
  end
  
  test '.quorum returns an int > 2/3 of node count - e.g. 3 for 4' do
    ConsensusNode.stub :count, 4 do
      assert_equal 3, ConsensusNode.quorum
    end
  end
  
end
