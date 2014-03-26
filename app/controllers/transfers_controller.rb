class TransfersController < ApplicationController
  
  respond_to :json
  
  def create
    source = Account.find_by_code(params[:source])
    destination = Account.find_by_code(params[:destination])
    transfer = Transfer.create(source: source, destination: destination, amount: params[:amount])
    respond_with transfer
  end
  
end
