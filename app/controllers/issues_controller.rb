class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    ledger = Ledger.find_by_name(issue_params[:ledger])
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKey::RSA.new(ledger.public_key)
    raise unless key.verify(digest, Base64.decode64(params[:signature]), issue_params.to_json)
    
    issue = Issue.create(ledger: ledger, amount: issue_params[:amount])
    respond_with issue
  rescue
    head :unprocessable_entity
  end
  
private
  
  def issue_params
    params.require(:issue).permit(:ledger, :amount)
  end
  
end
