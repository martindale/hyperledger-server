class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    issue = Issue.create(associated_issue_params)
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
