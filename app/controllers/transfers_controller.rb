class TransfersController < ApplicationController
  
  respond_to :json
  
  def create
    transfer = Transfer.create(associated_transfer_params)
    respond_with transfer
  end
  
private
  
  def transfer_params
    params.require(:transfer).permit(:source, :destination, :amount)
  end
  
  def associated_transfer_params
    { source: source, destination: destination, amount: transfer_params[:amount], client_signature: params[:signature] }
  end
  
  def combined_params
    { transfer: transfer_params }
  end
  
  def source
    Account.find_by_code(transfer_params[:source])
  end
  
  def destination
    Account.find_by_code(transfer_params[:destination])
  end
  
end
