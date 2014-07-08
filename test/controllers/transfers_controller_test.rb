require 'test_helper'

class TransfersControllerTest < ActionController::TestCase
  
  setup do
    @ledger_key = OpenSSL::PKey::RSA.new(2048)
    @source_key = OpenSSL::PKey::RSA.new(2048)
    @destination_key = OpenSSL::PKey::RSA.new(2048)
    
    @digest = OpenSSL::Digest::SHA256.new
    
    l = create_basic_ledger('Moonbucks', @ledger_key.public_key.to_pem)
    @s = l.accounts.create!(public_key: @source_key.public_key.to_pem)
    @d = l.accounts.create!(public_key: @destination_key.public_key.to_pem)
    l.update_attribute :primary_account, @s
    
    issue_params = { ledger: 'Moonbucks', amount: 2000 }
    sign = Base64.encode64(@ledger_key.sign(OpenSSL::Digest::SHA256.new, issue_params.to_json))
    l.issues.create!(amount: 2000, client_signature: sign)
    stub_request(:post, /.*/)
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
  
  test "valid POST should be forbidden if insufficient balance" do
    @s.update_attribute :balance, 0
    valid_post
    assert_equal '422', response.code
  end
  
private
  
  def valid_post
    data = { source: @s.code, destination: @d.code, amount: 500 }
    sig  = Base64.encode64 @source_key.sign(@digest, data.to_json)
    post :create, transfer: data.merge({client_signature: sig}), format: :json
  end
  
  def invalid_post
    data = { source: @s.code, destination: @d.code, amount: 500 }
    sig  = Base64.encode64 @destination_key.sign(@digest, data.to_json)
    post :create, transfer: data.merge({client_signature: sig}), format: :json
  end
  
end
