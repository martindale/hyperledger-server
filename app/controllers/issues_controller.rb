class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    issue = Issue.create(associated_issue_params)
    respond_with issue
  end
  
  def prepare
    issue = Issue.find_or_create_by(associated_issue_params)
    issue.add_prepare(authentication_params[:node], authentication_params[:signature])
    respond_with issue
  end
  
  def commit
    issue = Issue.find_or_create_by(associated_issue_params)
    issue.add_commit(authentication_params[:node], authentication_params[:signature])
    respond_with issue
  end
  
private
  
  def issue_params
    params.require(:issue).permit(:ledger, :amount)
  end
  
  def associated_issue_params
    { ledger: ledger, amount: issue_params[:amount], client_signature: params[:signature] }
  end
  
  def ledger
    @ledger ||= Ledger.find_by_name(issue_params[:ledger])
  end
  
  def combined_params
    { issue: issue_params, signature: params[:signature] }
  end
  
end
