require 'test_helper'

class LedgerTest < ActiveSupport::TestCase
  test "ledgers must validate incorrect RSA public keys" do
    ledger = Ledger.create(public_key: '123', name: 'Moonbucks', url: 'http://moonbucks.com')
    refute ledger.valid?
  end
  
  test "ledgers must validate correct RSA public keys" do
    pub_key = OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    ledger = Ledger.create(public_key: pub_key, name: 'Moonbucks', url: 'http://moonbucks.com')
    assert ledger.valid?
  end
  
  test "ledgers must not be confirmed if validation threshold not reached" do
    pub_key = OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    ConsensusPool.instance.stub :quorum, 1 do
      ledger = Ledger.create(public_key: pub_key, name: 'Moonbucks', url: 'http://moonbucks.com')
      refute ledger.confirmed?
    end
  end
  
  test "ledgers must be confirmed if validation threshold reached" do
    pub_key = OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    ledger = Ledger.create(public_key: pub_key, name: 'Moonbucks', url: 'http://moonbucks.com')
    ConsensusPool.instance.stub :quorum, 1 do
      ledger.add_confirmation
      assert ledger.confirmed?
    end
  end
  
  # test "POST with a new record should be broadcast to pool" do
  #   ConsensusPool.expect :broadcast, true
  #   
  # end
end
