class AccountsController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Account.find_by_code(params[:code])
  end
  
  def index
    respond_with Account.all
  end
  
  def create
    existing_account = Account.where(account_params).first
    if confirmed?(combined_params) && existing_account
      existing_account.add_confirmation
      head :no_content
    elsif !existing_account
      ledger = Ledger.find_by_name(account_params[:ledger])
      account = Account.create(public_key: account_params[:public_key], ledger: ledger)
      ConsensusPool.instance.broadcast(:account, combined_params) if account.valid?
      respond_with account
    else
      raise
    end
  
  end
  
private
  
  def account_params
    params.require(:account).permit(:public_key, :ledger)
  end
  
  def combined_params
    { account: account_params }
  end
  
end
