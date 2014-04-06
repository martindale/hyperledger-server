class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    currency = Currency.find_by_name(issue_params[:currency])
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKey::RSA.new(currency.public_key)
    raise unless key.verify(digest, Base64.decode64(params[:signature]), issue_params.to_json)
    
    issue = Issue.create(currency: currency, amount: issue_params[:amount])
    respond_with issue
  rescue
    head :unprocessable_entity
  end
  
private
  
  def issue_params
    params.require(:issue).permit(:currency, :amount)
  end
  
end
