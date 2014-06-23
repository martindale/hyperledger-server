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
    if confirmed? && existing_ledger
      existing_ledger.add_confirmation
      head :no_content
    elsif !existing_ledger
      ledger = Ledger.create(ledger_params)
      ledger.primary_account = ledger.accounts.build(primary_account_params)
      if ledger.valid?
        ConsensusPool.instance.broadcast(:ledger, { ledger: ledger_params,
                                                    primary_account: primary_account_params })
      end
      respond_with ledger
    else
      head :unprocessable_entity
    end
    
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
