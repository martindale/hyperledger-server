require 'test_helper'

class LedgerTest < ActiveSupport::TestCase
  
  setup do
    pub_key = OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    @ledger = Ledger.create(public_key: pub_key, name: 'Moonbucks', url: 'http://moonbucks.com')
  end
  
  test "ledgers must validate incorrect RSA public keys" do
    bad_ledger = Ledger.create(public_key: '123', name: 'Bad Ledger', url: 'http://badledger.com')
    refute bad_ledger.valid?
  end
  
  test "ledgers must not be prepared if validation threshold not reached" do
    refute @ledger.prepared?
  end
  
  test "ledgers must be prepared when prepare confirmation threshold reached" do
    @ledger.add_prepare(node: 'test', signature: '123')
    assert @ledger.prepared?
  end
  
  test "when the number of commit confirmations crosses a threshold mark as committed" do
    @ledger.add_commit(node: 'test', signature: '123')
    assert @ledger.committed?
  end
end
