class LedgersController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Ledger.find_by_name(params[:name])
  end
  
  def index
    respond_with Ledger.all
  end
  
  def create
    existing_ledger = Ledger.find_by_name(ledger_params[:name])
    if confirmed?
      ledger = Ledger.find_or_create_by(ledger_params)
      ledger.add_confirmation
    else
      ledger = Ledger.create(ledger_params)
    end
    ConsensusPool.instance.broadcast(:ledger, ledger_params) if ledger.valid? && !existing_ledger
    respond_with ledger
  end
  
private
  
  def ledger_params
    params.require(:ledger).permit(:public_key, :name, :url)
  end
  
end
