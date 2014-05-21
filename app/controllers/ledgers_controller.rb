class LedgersController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Ledger.find_by_name(params[:name])
  end

  def index
    respond_with Ledger.all
  end

  def create
    ledger = Ledger.create(ledger_params)
    respond_with ledger
  end
  
private
  
  def ledger_params
    params.permit(:public_key, :name, :url)
  end
  
end
