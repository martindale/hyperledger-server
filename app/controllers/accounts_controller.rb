class AccountsController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Account.find_by_code(params[:code])
  end

  def index
    respond_with Account.all
  end

  def create
    currency = Account.create(params[:account])
  end
  
end
