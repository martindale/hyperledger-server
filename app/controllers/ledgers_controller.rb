class LedgersController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Ledger.find_by_name(params[:name])
  end
  
  def index
    respond_with Ledger.all
  end
  
  def create
    
    existing_ledger = Ledger.where(ledger_params).first
    if confirmed?
      ledger = Ledger.find_or_create_by(ledger_params)
      ledger.add_confirmation
    else
      ledger = Ledger.create(ledger_params)
      primary_account = Account.new(primary_account_params)
      primary_account.ledger = ledger
    end
    
    if ledger.valid? && !existing_ledger
      ConsensusPool.instance.broadcast(:ledger, ledger_params)
    end
    
    respond_with ledger
    
  rescue ActionController::ParameterMissing
    head :unprocessable_entity
  end
  
private
  
  def ledger_params
    params.require(:ledger).permit(:public_key, :name, :url)
  end
  
  def primary_account_params
    params.fetch(:primary_account).permit(:public_key)
  end
  
end
