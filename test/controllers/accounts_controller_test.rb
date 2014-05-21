require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  setup do
    Ledger.create!(public_key: '123', name: 'Moonbucks', url: 'http://moonbucks.com')
    key = OpenSSL::PKey::RSA.new 2048
    @public_key = key.public_key.to_pem
  end
  
  test "valid POST should be successful" do
    post :create, public_key: @public_key, ledger: 'Moonbucks', format: :json
    assert_equal '201', response.code
  end
    
  test "POST with bad key should be unsuccessful" do
    post :create, public_key: '456', ledger: 'Moonbucks', format: :json
    assert_equal '422', response.code
  end
    
end
