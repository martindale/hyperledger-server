class LedgersController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Ledger.find_by_name(params[:name])
  end
  
  def index
    respond_with Ledger.all
  end
  
  def create
    ledger = Ledger.new(ledger_params)
    ledger.primary_account = ledger.accounts.build(primary_account_params)
    ledger.save
    respond_with ledger
  end
  
  def prepare
    ledger = Ledger.find_or_initialize_by(ledger_params)
    ledger.primary_account = ledger.accounts.find_or_initialize_by(primary_account_params)
    if ledger.save
      ledger.add_prepare(authentication_params[:node], authentication_params[:signature])
      ledger.primary_account.add_prepare(authentication_params[:node], authentication_params[:signature])
      head :no_content
    else
      head :unprocessable_entity
    end
  end
  
  def commit
    ledger = Ledger.find_or_initialize_by(ledger_params)
    ledger.primary_account = ledger.accounts.find_or_initialize_by(primary_account_params)
    if ledger.save
      ledger.add_commit(authentication_params[:node], authentication_params[:signature])
      ledger.primary_account.add_commit(authentication_params[:node], authentication_params[:signature])
      head :no_content
    else
      head :unprocessable_entity
    end
  end
  
private
  
  def ledger_params
    params.require(:ledger).permit(:public_key, :name, :url)
  end
  
  def primary_account_params
    params.fetch(:primary_account).permit(:public_key)
  end
  
end
