class AccountsController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Account.find_by_code(params[:code])
  end

  def index
    respond_with Account.all
  end

  def create
    currency = Currency.find_by_name(params[:currency])
    account = Account.create(public_key: params[:public_key], currency: currency)
    respond_with account
  end
  
end
