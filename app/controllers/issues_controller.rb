class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    ledger = Ledger.find_by_name(issue_params[:ledger])
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKey::RSA.new(ledger.public_key)
    raise unless key.verify(digest, Base64.decode64(params[:signature]), issue_params.to_json)
    
    existing_issue = Issue.where(issue_params).first
    if confirmed?(combined_params) && existing_issue
      existing_issue.add_confirmation
      head :no_content
    elsif !existing_issue
      issue = Issue.create(ledger: ledger, amount: issue_params[:amount])
      ConsensusPool.instance.broadcast(:issue, combined_params) if issue.valid?
      respond_with issue
    else
      raise
    end
    
  rescue
    head :unprocessable_entity
  end
  
private
  
  def issue_params
    params.require(:issue).permit(:ledger, :amount)
  end
  
  def combined_params
    { issue: issue_params, signature: params[:signature] }
  end
  
end
