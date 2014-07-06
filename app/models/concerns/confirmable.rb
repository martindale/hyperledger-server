module Confirmable
  extend ActiveSupport::Concern
  
  included do
    has_many    :prepare_confirmations, as: :confirmable
    has_many    :commit_confirmations, as: :confirmable
    
    after_create do |confirmable|
      ConsensusNode.all.each do |node|
        confirmable.prepare_confirmations.create(node: node.url)
        confirmable.commit_confirmations.create(node: node.url)
      end
    end
  end
  
  def add_prepare(node, signature)
    quorum = ConsensusPool.instance.quorum
    prepare = self.prepare_confirmations.find_by_node(node)
    if prepare
      prepare.signature = signature
      prepare.save
      self.prepared = true if prepare_confirmations.signed.count >= quorum
    end
  end
  
  def add_commit(node, signature)
    quorum = ConsensusPool.instance.quorum
    commit = self.commit_confirmations.find_by_node(node)
    if commit
      commit.signature = signature
      commit.save
      self.committed = true if commit_confirmations.signed.count >= quorum
    end
  end
  
end