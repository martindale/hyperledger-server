require 'test_helper'

class LedgerTest < ActiveSupport::TestCase
  
  setup do
    node_key = OpenSSL::PKey::RSA.new(2048)
    ConsensusNode.create!(url: 'localtest-1', public_key: node_key.public_key.to_pem)
    ConsensusNode.create!(url: 'localtest-2', public_key: node_key.public_key.to_pem)
    
    pub_key = OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    
    stub_request(:post, /.*/)
    
    @ledger = Ledger.create!(public_key: pub_key, name: 'Moonbucks', url: 'http://moonbucks.com')
  end
  
  test "ledgers must validate incorrect RSA public keys" do
    bad_ledger = Ledger.create(public_key: '123', name: 'Bad Ledger', url: 'http://badledger.com')
    refute bad_ledger.valid?
  end
  
  # Prepare confirmations
  test "ledgers must create prepare confirmations for each node in the consensus pool" do
    assert_equal 2, @ledger.prepare_confirmations.count
  end
  
  test "ledgers must not be prepared if validation threshold not reached" do
    @ledger.add_prepare('localtest-1', '123')
    refute @ledger.prepared?
  end
  
  test "ledgers must be prepared when prepare confirmation threshold reached" do
    @ledger.add_prepare('localtest-1', '123')
    @ledger.add_prepare('localtest-2', '123')
    assert @ledger.prepared?
  end
  
  test "when the number of commit confirmations crosses a threshold mark as committed" do
    @ledger.add_commit('localtest-1', '123')
    @ledger.add_commit('localtest-2', '123')
    assert @ledger.committed?
  end
end
