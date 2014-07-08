class TransfersController < ApplicationController
  
  respond_to :json
  
  def create
    transfer = Transfer.create(associated_transfer_params)
    respond_with transfer
  end
  
  def prepare
    transfer = Transfer.find_or_create_by(associated_transfer_params)
    transfer.add_prepare(authentication_params[:node], authentication_params[:signature])
    respond_with transfer
  end
  
  def commit
    transfer = Transfer.find_or_create_by(associated_transfer_params)
    transfer.add_commit(authentication_params[:node], authentication_params[:signature])
    respond_with transfer
  end
  
private
  
  def transfer_params
    params.require(:transfer).permit(:source, :destination, :amount, :resource_signature)
  end
  
  def associated_transfer_params
    transfer_params.merge({ source: source, destination: destination })
  end
  
  def source
    Account.find_by_code(transfer_params[:source])
  end
  
  def destination
    Account.find_by_code(transfer_params[:destination])
  end
  
end
