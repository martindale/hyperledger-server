require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  setup do
    ledger_key = OpenSSL::PKey::RSA.new(2048).public_key.to_pem
    create_basic_ledger('Moonbucks', ledger_key)
    
    key = OpenSSL::PKey::RSA.new(2048)
    @public_key = key.public_key.to_pem
    stub_request(:post, /.*/)
    request.accept = 'application/json'
  end
  
  test "valid POST should be successful" do
    post :create, account: { public_key: @public_key, ledger: 'Moonbucks' }
    assert_equal '201', response.code
  end
  
  test "POST with bad key should be unsuccessful" do
    post :create, account: { public_key: '456', ledger: 'Moonbucks' }
    assert_equal '422', response.code
  end
  
  test "prepare message should create resource" do
    data = { account: { public_key: @public_key, ledger: 'Moonbucks' }}
    assert_difference 'Account.count', 1 do
      post :prepare, data.merge(self_confirmation(data))
    end
  end
  
end
