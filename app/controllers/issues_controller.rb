class IssuesController < ApplicationController
  
  respond_to :json
  
  def create
    i = Issue.new(amount: params[:amount])
    i.currency_id = Currency.find_by_name(params[:currency]).id
    i.save
    respond_with i
  end
  
end
