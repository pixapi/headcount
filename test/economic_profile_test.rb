require_relative 'test_helper'
require './lib/economic_profile'

class EconomicProfileTest < Minitest::Test
  def test_it_has_a_class
    ep = EconomicProfile.new
    assert_instance_of EconomicProfile, ep
  end
end
