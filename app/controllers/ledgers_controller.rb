class LedgersController < ApplicationController
  
  respond_to :json
  
  def show
    respond_with Ledger.find_by_name(params[:name])
  end
  
  def index
    respond_with Ledger.all
  end
  
  def create
    ledger = Ledger.new(ledger_params)
    
    if ledger.save
      ledger.primary_account = ledger.accounts.create(primary_account_params)
      ledger.add_prepare(prepare_params[:node], prepare_params[:signature])
    end
    
    respond_with ledger
  rescue ActionController::ParameterMissing
    head :unprocessable_entity
  end
  
  def prepare
    ledger = Ledger.find_or_create_by(ledger_params)
    ledger.primary_account = ledger.accounts.find_or_create_by(primary_account_params)
    ledger.add_prepare(authentication_params[:node], authentication_params[:signature])
    respond_with ledger
  end
  
  def commit
    ledger = Ledger.find_or_create_by(ledger_params)
    ledger.primary_account = ledger.accounts.find_or_create_by(primary_account_params)
    ledger.add_commit(authentication_params[:node], authentication_params[:signature])
    respond_with ledger
  end
  
private
  
  def ledger_params
    params.require(:ledger).permit(:public_key, :name, :url)
  end
  
  def primary_account_params
    params.fetch(:primary_account).permit(:public_key)
  end
  
  def combined_params
    { ledger: ledger_params, primary_account: primary_account_params }
  end
  
  def combined_commit_params
    combined_params.merge({ commit: true })
  end
  
  def prepare_params
    key = OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'])
    digest = OpenSSL::Digest::SHA256.new
    signature = Base64.encode64 key.sign(digest, combined_params.to_json)
    { node: ENV['SERVER_NAME'], signature: signature }
  end
  
end
