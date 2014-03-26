class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    currency = Currency.find_by_name(params[:currency])
    issue = Issue.create(amount: params[:amount], currency: currency)
    respond_with issue
  end
  
end
