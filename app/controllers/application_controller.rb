class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  # http://kevinthompson.info/blog/2013/07/14/customizing-the-strong-parameters-missing-parameter-response.html
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    error = {}
    error[parameter_missing_exception.param] = ['parameter is required']
    response = { errors: [error] }
    respond_to do |format|
      format.json { render json: response, status: :unprocessable_entity }
    end
  end
  
private
  
  def authentication_params
    params.fetch(:authentication, {}).permit(:node, :signature)
  end
  
end
