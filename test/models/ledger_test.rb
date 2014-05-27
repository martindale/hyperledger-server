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
    ConsensusPool.quorum = 1
    pub_key = OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    ledger = Ledger.create(public_key: pub_key, name: 'Moonbucks', url: 'http://moonbucks.com')
    refute ledger.confirmed?
  end
  
  test "ledgers must be confirmed if validation threshold reached" do
    ConsensusPool.quorum = 1
    pub_key = OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    ledger = Ledger.create(public_key: pub_key, name: 'Moonbucks', url: 'http://moonbucks.com')
    ledger.add_confirmation
    assert ledger.confirmed?
  end
end
