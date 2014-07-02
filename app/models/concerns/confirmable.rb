module Confirmable
  extend ActiveSupport::Concern
  
  def add_prepare(prepare_params)
    quorum = ConsensusPool.instance.quorum
    self.prepare_confirmations.create(prepare_params)
    self.prepared = true if prepare_confirmations.count >= quorum
  end
  
  def add_commit(commit_params)
    quorum = ConsensusPool.instance.quorum
    self.commit_confirmations.create(commit_params)
    self.committed = true if commit_confirmations.count >= quorum
  end
  
end