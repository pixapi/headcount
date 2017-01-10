require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test
  def test_it_has_a_class
    st = StatewideTest.new
    assert_instance_of StatewideTest, dr
  end


end
