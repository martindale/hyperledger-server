class TransfersController < ApplicationController
  
  respond_to :json
  
  def create
    source = Account.find_by_code(transfer_params[:source])
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKey::RSA.new(source.public_key)
    raise unless key.verify(digest, Base64.decode64(params[:signature]), transfer_params.to_json)
    
    existing_transfer = Transfer.where(transfer_params).first
    if confirmed?(transfer_params) && existing_transfer
      existing_transfer.add_confirmation
      head :no_content
    elsif !existing_transfer
      destination = Account.find_by_code(transfer_params[:destination])
      transfer = Transfer.create(source: source, destination: destination, amount: transfer_params[:amount])
      ConsensusPool.instance.broadcast(:transfer, transfer_params) if transfer.valid?
      respond_with transfer
    else
      raise
    end
    
  rescue
    head :unprocessable_entity
  end
  
private
  
  def transfer_params
    params.require(:transfer).permit(:source, :destination, :amount)
  end
  
end
