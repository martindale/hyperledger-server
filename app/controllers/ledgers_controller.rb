class LedgersController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Ledger.find_by_name(params[:name])
  end

  def index
    respond_with Ledger.all
  end

  def create
    if confirmed?
      ledger = Ledger.find_or_create_by(ledger_params)
      ledger.add_confirmation
    else
      ledger = Ledger.create(ledger_params)
    end
    respond_with ledger
  end
  
private
  
  def ledger_params
    params.require(:ledger).permit(:public_key, :name, :url)
  end
  
  def confirmation_params
    params.fetch(:confirmation, {}).permit(:server, :signature)
  end
  
  def confirmed?
    return false if confirmation_params.empty?
    server_id = confirmation_params[:server]
    signature = confirmation_params[:signature]
    ConsensusPool.instance.valid_confirmation?(server_id, signature, ledger_params)
  end
  
end
