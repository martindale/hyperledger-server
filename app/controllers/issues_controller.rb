class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    raise 'Invalid signature' unless valid_signature?
    
    if confirmed?(combined_params)
      issue = Issue.find_or_create_by(associated_issue_params)
    else
      issue = Issue.create(associated_issue_params)
    end
    
    if issue.valid?
      ConsensusPool.instance.broadcast(:issue, combined_params)
      issue.add_confirmation
    end
    
    respond_with issue
  rescue
    head :unprocessable_entity
  end
  
private
  
  def issue_params
    params.require(:issue).permit(:ledger, :amount)
  end
  
  def associated_issue_params
    { ledger: ledger, amount: issue_params[:amount] }
  end
  
  def ledger
    @ledger ||= Ledger.find_by_name(issue_params[:ledger])
  end
  
  def combined_params
    { issue: issue_params, signature: params[:signature] }
  end
  
  def valid_signature?
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKey::RSA.new(ledger.public_key)
    key.verify(digest, Base64.decode64(params[:signature]), issue_params.to_json)
  rescue
    false
  end
  
end
