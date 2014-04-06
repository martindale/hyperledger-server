require 'test_helper'

class TransfersControllerTest < ActionController::TestCase
  
  setup do
    @k1 = OpenSSL::PKey::RSA.new(2048)
    @k2 = OpenSSL::PKey::RSA.new(2048)
    @pk1 = @k1.public_key.to_pem
    @pk2 = @k2.public_key.to_pem
    @digest = OpenSSL::Digest::SHA256.new

    c = Currency.create!(public_key: @pk1, name: 'Moonbucks', url: 'http://moonbucks.com')
    Issue.create!(currency: c, amount: 2000)
    @s = c.primary_account
    @d = Account.create!(public_key: @pk2, currency: c)
  end
  
  test "valid POST should be successful" do
    valid_post
    assert_equal '201', response.code
  end
  
  test "valid POST should decrease source account balance" do
    valid_post
    assert_equal 1500, @s.reload.balance
  end
  
  test "valid POST should increase destination account balance" do
    valid_post
    assert_equal 500, @d.reload.balance
  end
  
  test "invalid POST should be unsuccessful" do
    invalid_post
    assert_equal '422', response.code
  end
  
  test "invalid POST should not change source account balance" do
    invalid_post
    assert_equal 2000, @s.reload.balance
  end
  
  test "invalid POST should not change destination account balance" do
    invalid_post
    assert_equal 0, @d.reload.balance
  end
  
private
  
  def valid_post
    data = { source: @s.code, destination: @d.code, amount: 500 }
    sig  = Base64.encode64 @k1.sign(@digest, data.to_json)
    post :create, transfer: data, signature: sig, format: :json
  end
  
  def invalid_post
    data = { source: @s.code, destination: @d.code, amount: 500 }
    sig  = Base64.encode64 @k2.sign(@digest, data.to_json)
    post :create, transfer: data, signature: sig, format: :json
  end
  
end
