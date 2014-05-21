class AccountsController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Account.find_by_code(params[:code])
  end
  
  def index
    respond_with Account.all
  end
  
  def create
    ledger = Ledger.find_by_name(params[:ledger])
    account = Account.create(public_key: params[:public_key], ledger: ledger)
    respond_with account
  end
  
end
