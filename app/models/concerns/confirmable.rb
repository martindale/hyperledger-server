module Confirmable
  extend ActiveSupport::Concern
  
  included do
    has_many :prepare_confirmations, as: :confirmable
    has_many :commit_confirmations, as: :confirmable
    
    after_create do
      ConsensusNode.broadcast_prepare(self.class.name.downcase.to_sym, broadcast_params)
      ConsensusNode.all.each do |node|
        prepare_confirmations.create(node: node.url)
        commit_confirmations.create(node: node.url)
      end
    end
  end
  
  def add_prepare(node, signature)
    prepare = self.prepare_confirmations.find_by_node(node)
    if prepare
      prepare.signature = signature
      prepare.save
      self.prepared = true if prepare_confirmations.signed.count >= ConsensusNode.quorum
    end
  end
  
  def add_commit(node, signature)
    commit = self.commit_confirmations.find_by_node(node)
    if commit
      commit.signature = signature
      commit.save
      self.committed = true if commit_confirmations.signed.count >= ConsensusNode.quorum
    end
  end
  
end