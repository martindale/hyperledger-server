require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  
  setup do
    @key = OpenSSL::PKey::RSA.new(2048)
    @public_key = @key.public_key.to_pem
    Currency.create!(public_key: @public_key, name: 'Moonbucks', url: 'http://moonbucks.com')
  end
  
  test "valid POST should be successful" do
    valid_post
    assert_equal '201', response.code
  end
  
  test "valid POST should increase primary account balance" do
    valid_post
    assert_equal 1000, Account.first.balance
  end
  
  test "invalid POST should be unsuccessful" do
    invalid_post
    assert_equal '422', response.code
  end
  
  test "invalid POST should not change primary account balance" do
    invalid_post
    assert_equal 0, Account.first.balance
  end
  
private
  
  def valid_post
    data = { currency: 'Moonbucks', amount: 1000 }
    sig  = Base64.encode64 @key.sign(OpenSSL::Digest::SHA256.new, data.to_json)
    post :create, issue: data, signature: sig, format: :json
  end
  
  def invalid_post
    bad_key = OpenSSL::PKey::RSA.new(2048)
    data = { currency: 'Moonbucks', amount: 1000 }
    sig  = Base64.encode64 bad_key.sign(OpenSSL::Digest::SHA256.new, data.to_json)
    post :create, issue: data, signature: sig, format: :json
  end
  
end
