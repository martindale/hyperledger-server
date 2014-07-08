class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    issue = Issue.create(associated_issue_params)
    respond_with issue
  end
  
  def prepare
    issue = Issue.find_or_create_by(associated_issue_params)
    if issue.save
      issue.add_prepare(authentication_params[:node], authentication_params[:signature])
    end
    respond_with issue
  end
  
  def commit
    issue = Issue.find_or_create_by(associated_issue_params)
    if issue.save
      issue.add_commit(authentication_params[:node], authentication_params[:signature])
    end
    respond_with issue
  end
  
private
  
  def issue_params
    params.require(:issue).permit(:ledger, :amount, :resource_signature)
  end
  
  def associated_issue_params
    issue_params.merge({ ledger: ledger })
  end
  
  def ledger
    @ledger ||= Ledger.find_by_name(issue_params[:ledger])
  end
  
end
