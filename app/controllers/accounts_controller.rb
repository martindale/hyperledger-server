class AccountsController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Account.find_by_code(params[:code])
  end
  
  def index
    respond_with Account.all
  end
  
  def create
    account = Account.create(associated_account_params)
    respond_with account
  end
  
  def prepare
    account = Account.find_or_create_by(associated_account_params)
    account.add_prepare(authentication_params[:node], authentication_params[:signature])
    respond_with account
  end
  
  def commit
    account = Account.find_or_create_by(associated_account_params)
    account.add_commit(authentication_params[:node], authentication_params[:signature])
    respond_with issaccountue
  end
  
private
  
  def account_params
    params.require(:account).permit(:public_key, :ledger)
  end
  
  def associated_account_params
    ledger = Ledger.find_by_name(account_params[:ledger])
    { public_key: account_params[:public_key], ledger: ledger }
  end
  
end
