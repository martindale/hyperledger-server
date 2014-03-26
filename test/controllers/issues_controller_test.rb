require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  
  setup do
    Currency.create!(public_key: '123', name: 'Moonbucks', url: 'http://moonbucks.com')
  end
  
  test "valid POST should be successful" do
    post :create, currency: 'Moonbucks', amount: 1000, format: :json
    assert_equal '201', response.code
  end
  
  test "valid POST should increase primary wallet balance" do
    post :create, currency: 'Moonbucks', amount: 1000, format: :json
    assert_equal 1000, Account.first.balance
  end
  
end
