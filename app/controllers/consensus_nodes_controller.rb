class ConsensusNodesController < ApplicationController
  
  respond_to :json
  
  def index
    respond_with ConsensusNode.all
  end
  
end
