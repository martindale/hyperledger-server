class TransfersController < ApplicationController
  
  respond_to :json
  
  def create
    raise 'Invalid signature' unless valid_signature?
    
    if confirmed?(combined_params)
      transfer = Transfer.find_or_create_by(associated_transfer_params)
    else
      transfer = Transfer.create(associated_transfer_params)
    end
    
    if transfer.valid?
      ConsensusPool.instance.broadcast(:transfer, combined_params)
      transfer.add_confirmation
    end
    
    respond_with transfer
  rescue
    head :unprocessable_entity
  end
  
private
  
  def transfer_params
    params.require(:transfer).permit(:source, :destination, :amount)
  end
  
  def associated_transfer_params
    { source: source, destination: destination, amount: transfer_params[:amount] }
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
  
  def valid_signature?
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKey::RSA.new(source.public_key)
    key.verify(digest, Base64.decode64(params[:signature]), transfer_params.to_json)
  rescue
    false
  end
  
end
