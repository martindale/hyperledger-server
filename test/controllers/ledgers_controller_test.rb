require 'test_helper'

class LedgersControllerTest < ActionController::TestCase
  
  setup do
    key = OpenSSL::PKey::RSA.new 2048
    @public_key = key.public_key.to_pem
  end
  
  test "valid POST should be successful" do
    post :create, public_key: @public_key, name: 'Moonbucks', url: 'moonbucks.com', format: :json
    assert_equal '201', response.code
  end
  
  test "POST with a bad public key should be unsuccessful" do
    post :create, public_key: '123', name: 'Moonbucks', url: 'moonbucks.com', format: :json
    assert_equal '422', response.code
  end
  
  test "duplicate POST should not be successful" do
    Ledger.create(public_key: @public_key, name: 'Moonbucks', url: 'moonbucks.com')
    post :create, public_key: @public_key, name: 'Moonbucks', url: 'moonbucks.com', format: :json
    refute_equal '201', response.code
  end
  
end
