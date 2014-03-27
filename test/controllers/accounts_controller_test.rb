require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  setup do
    Currency.create!(public_key: '123', name: 'Moonbucks', url: 'http://moonbucks.com')
  end
  
  test "valid POST should be successful" do
    post :create, public_key: '456', currency: 'Moonbucks', format: :json
    assert_equal '201', response.code
  end
    
end
