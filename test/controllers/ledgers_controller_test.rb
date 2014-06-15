require 'test_helper'

class LedgersControllerTest < ActionController::TestCase
  
  setup do
    ledger_key = OpenSSL::PKey::RSA.new 2048
    account_key = OpenSSL::PKey::RSA.new 2048
    
    @public_key = ledger_key.public_key.to_pem
    @ledger_data = { public_key: @public_key, name: 'Moonbucks', url: 'moonbucks.com' }
    @account_data = { public_key: account_key.public_key.to_pem }
    
    stub_request(:post, /.*/)
  end
  
  test "valid POST should be successful" do
    post :create, ledger: @ledger_data, primary_account: @account_data, format: :json
    assert_equal '201', response.code
  end
  
  test "POST with a bad public key should be unsuccessful" do
    post :create, ledger: { public_key: '123', name: 'Moonbucks', url: 'moonbucks.com' }, primary_account: @account_data, format: :json
    assert_equal '422', response.code
  end
  
  test "POST without primary account data should be unsuccessful" do
    post :create, ledger: @ledger_data, format: :json
    assert_equal '422', response.code
  end
  
  test "duplicate POST should not be successful" do
    Ledger.create(@ledger_data)
    post :create, ledger: @ledger_data, primary_account: @account_data, format: :json
    refute_equal '201', response.code
  end
  
  test "POST with confirmation should create resource" do
    assert_difference 'Ledger.count', 1 do
      ConsensusPool.instance.stub :valid_confirmation?, true do
        post :create, ledger: @ledger_data, confirmation: {server: 'one', signature: '123'}, format: :json
      end
    end
  end
  
  test "POST with valid confirmation should add a confirmation" do
    ledger = Ledger.create(@ledger_data)
    ConsensusPool.instance.stub :valid_confirmation?, true do
      post :create, ledger: @ledger_data, primary_account: @account_data, confirmation: {server: 'one', signature: '123'}, format: :json
    end
    assert_equal 1, ledger.reload.confirmation_count
  end
  
  test "POST with invalid confirmation should not add a confirmation" do
    ledger = Ledger.create(@ledger_data)
    ConsensusPool.instance.stub :valid_confirmation?, false do
      post :create, ledger: @ledger_data, primary_account: @account_data, confirmation: {server: 'one', signature: '123'}, format: :json
    end
    assert_equal 0, ledger.reload.confirmation_count
  end
  
  test "POST which creates a resource should broadcast the message" do
    key = OpenSSL::PKey::RSA.new(2048)
    mock_server = { url: 'test', public_key: key.public_key.to_pem }
    ConsensusPool.instance.stub :servers, [mock_server] do
      post :create, ledger: @ledger_data, primary_account: @account_data, format: :json
    end
    assert_requested(:post, "#{mock_server[:url]}/ledgers")
  end
  
  test "POST which confirms an existing resource should not broadcast" do
    key = OpenSSL::PKey::RSA.new(2048)
    mock_server = { url: 'test', public_key: key.public_key.to_pem }
    Ledger.create(@ledger_data)
    ConsensusPool.instance.stub :servers, [mock_server] do
      post :create, ledger: @ledger_data, primary_account: @account_data, format: :json
    end
    assert_not_requested(:post, "#{mock_server[:url]}/ledgers")
  end
  
end
