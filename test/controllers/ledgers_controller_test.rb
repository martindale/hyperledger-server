require 'test_helper'

class LedgersControllerTest < ActionController::TestCase
  
  setup do
    ledger_key = OpenSSL::PKey::RSA.new 2048
    account_key = OpenSSL::PKey::RSA.new 2048
    @node_key = OpenSSL::PKey::RSA.new 2048
    
    @public_key = ledger_key.public_key.to_pem
    @ledger_data = { public_key: @public_key, name: 'Moonbucks', url: 'moonbucks.com' }
    @account_data = { public_key: account_key.public_key.to_pem }
    
    @node = ConsensusNode.create!(url: 'test', public_key: @node_key.public_key.to_pem)
    
    stub_request(:post, /.*/)
    request.accept = 'application/json'
  end
  
  test "valid POST should be successful" do
    post :create, ledger: @ledger_data, primary_account: @account_data
    assert_equal '201', response.code
  end
  
  test "POST with a bad public key should be unsuccessful" do
    post :create, ledger: { public_key: '123', name: 'Moonbucks', url: 'moonbucks.com' }, primary_account: @account_data
    assert_equal '422', response.code
  end
  
  test "POST without primary account data should be unsuccessful" do
    post :create, ledger: @ledger_data
    assert_equal '422', response.code
  end
  
  test "duplicate POST should not be successful" do
    Ledger.create(@ledger_data)
    post :create, ledger: @ledger_data, primary_account: @account_data
    refute_equal '201', response.code
  end
  
  # Prepare messages
  test "valid POST with signature should create resource" do
    assert_difference 'Ledger.count', 1 do
      post :create, valid_prepare_post
    end
  end
  
  test "valid POST which creates a resource should broadcast to the other nodes" do
    post :create, valid_prepare_post
    assert_requested(:post, 'test/ledgers')
  end
  
  test "valid POST which confirms an existing resource should not broadcast" do
    Ledger.create!(@ledger_data)
    post :create, valid_prepare_post
    assert_not_requested(:post, 'test/ledgers')
  end
  
  # Prepare records
  test "valid POST should add prepare record for self" do
    assert_difference 'PrepareConfirmation.count', 1 do
      post :create, ledger: @ledger_data, primary_account: @account_data
    end
  end
  
  test "valid POST with signature for new resource should add prepare record" do
    assert_difference 'PrepareConfirmation.count', 1 do
      post :create, valid_prepare_post
    end
  end
  
  test "valid POST which confirms an existing resource should create a prepare record" do
    ledger = Ledger.create!(@ledger_data)
    assert_difference 'ledger.prepare_confirmations.count', 1 do
      post :create, valid_prepare_post
    end
  end
  
  test "POST with invalid signature should not add a prepare record" do
    ledger = Ledger.create!(@ledger_data)
    assert_no_difference 'ledger.prepare_confirmations.count' do
      post :create, ledger: @ledger_data,
                    primary_account: @account_data,
                    authentication: { node: 'test', signature: '123' }
    end
  end
  
  # Commit records
  test "POST with commit should add a commit record" do
    ledger = Ledger.create!(@ledger_data)
    assert_difference 'ledger.commit_confirmations.count', 1 do
      post :create, valid_commit_post
    end
  end
  
private
  
  def valid_prepare_post
    digest = OpenSSL::Digest::SHA256.new
    data = { ledger: @ledger_data, primary_account: @account_data }
    signature = Base64.encode64 @node_key.sign(digest, data.to_json)
    data.merge({ authentication: { node: 'test', signature: signature } })
  end
  
  def valid_commit_post
    digest = OpenSSL::Digest::SHA256.new
    data = { ledger: @ledger_data, primary_account: @account_data, commit: true }
    signature = Base64.encode64 @node_key.sign(digest, data.to_json)
    data.merge({ authentication: { node: 'test', signature: signature } })
  end
  
end
