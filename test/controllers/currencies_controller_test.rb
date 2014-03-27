require 'test_helper'

class CurrenciesControllerTest < ActionController::TestCase
  
  test "valid POST should be successful" do
    post :create, public_key: '123', name: 'Moonbucks', url: 'moonbucks.com', format: :json
    assert_equal '201', response.code
  end
  
  test "duplicate POST should not be successful" do
    Currency.create(public_key: '123', name: 'Moonbucks', url: 'moonbucks.com')
    post :create, public_key: '123', name: 'Moonbucks', url: 'moonbucks.com', format: :json
    refute_equal '201', response.code
  end
  
end
