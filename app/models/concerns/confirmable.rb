module Confirmable
  extend ActiveSupport::Concern
  
  included do
    has_many :prepare_confirmations, as: :confirmable
    has_many :commit_confirmations, as: :confirmable
    
    after_create do
      ConsensusNode.all.each do |node|
        prepare_confirmations.create(node: node.url)
        commit_confirmations.create(node: node.url)
      end
      add_self_prepare
      ConsensusNode.broadcast_prepare(self.class.name.downcase.to_sym, broadcast_params)
    end
  end
  
  def add_prepare(node, signature)
    prepare = self.prepare_confirmations.find_by_node(node)
    if prepare
      prepare.signature = signature
      prepare.save
      
      if prepare_confirmations.signed.count >= ConsensusNode.quorum && !prepared
        self.prepared = true
        save
        add_self_commit
        ConsensusNode.broadcast_commit(self.class.name.downcase.to_sym, broadcast_params)
      end
    end
  end
  
  def add_commit(node, signature)
    commit = self.commit_confirmations.find_by_node(node)
    if commit
      commit.signature = signature
      commit.save
      
      if commit_confirmations.signed.count >= ConsensusNode.quorum && !committed
        self.committed = true
        if save && respond_to?(:after_commit)
          after_commit
        end
      end
    end
  end
  
  def add_self_prepare
    add_prepare(ENV['NODE_URL'], sign(broadcast_params))
  end
  
  def add_self_commit
    add_commit(ENV['NODE_URL'], sign(broadcast_params.merge({commit: true})))
  end
  
private
  
  def sign(data)
    key = OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'].gsub('\n',"\n"))
    digest = OpenSSL::Digest::SHA256.new
    signature = Base64.encode64 key.sign(digest, data.to_json)
  end
  
end