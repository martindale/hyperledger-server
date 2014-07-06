class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
private
  
  def authentication_params
    params.fetch(:authentication, {}).permit(:node, :signature)
  end
  
  def confirmed?(data)
    return false if authentication_params.empty?
    node = ConsensusNode.find_by_url(authentication_params[:node])
    node.valid_confirmation?(node, authentication_params[:signature], data)
  end
  
end
