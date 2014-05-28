require 'test_helper'

class ConsensusPoolTest < ActiveSupport::TestCase
  
  test 'the consensus pool is initialised' do
    assert_equal 'Test', ConsensusPool.instance.name
  end
  
end