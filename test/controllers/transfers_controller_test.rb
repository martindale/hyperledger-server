require 'test_helper'

class TransfersControllerTest < ActionController::TestCase
  
  setup do
    c = Currency.create!(public_key: '123', name: 'Moonbucks', url: 'http://moonbucks.com')
    Issue.create!(currency_id: c.id, amount: 2000)
    @s = c.primary_account
    @d = Account.create!(public_key: '456', currency_id: c.id)
  end
  
  test "valid POST should be successful" do
    post :create, source: @s.code, destination: @d.code, amount: 500, format: :json
    assert_equal '201', response.code
  end
  
  test "valid POST should decrease source account balance" do
    post :create, source: @s.code, destination: @d.code, amount: 500, format: :json
    assert_equal 1500, @s.reload.balance
  end
  
  test "valid POST should increase destination account balance" do
    post :create, source: @s.code, destination: @d.code, amount: 500, format: :json
    assert_equal 500, @d.reload.balance
  end
  
end
