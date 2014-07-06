class AccountsController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Account.find_by_code(params[:code])
  end
  
  def index
    respond_with Account.all
  end
  
  def create
    if confirmed?(combined_params)
      account = Account.find_or_create_by(associated_account_params)
    else
      account = Account.create(associated_account_params)
    end
    
    respond_with account
  end
  
private
  
  def account_params
    params.require(:account).permit(:public_key, :ledger)
  end
  
  def associated_account_params
    ledger = Ledger.find_by_name(account_params[:ledger])
    { public_key: account_params[:public_key], ledger: ledger }
  end
  
  def combined_params
    { account: account_params }
  end
  
end
