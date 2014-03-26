class CurrenciesController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Currency.find_by_name(params[:name])
  end

  def index
    respond_with Currency.all
  end

  def create
    currency = Currency.create(params[:currency])
  end
  
end
