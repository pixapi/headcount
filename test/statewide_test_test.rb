require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test
  def setup
    @hash = {:name=>"ACADEMY 20", :third_grade=>{2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}, 2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662}, 2011=>{:math=>0.819, :reading=>0.867,
      :writing=>0.678}, 2012=>{:reading=>0.87, :math=>0.83, :writing=>0.65517}, 2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687}, 2014=>{:math=>0.8345, :reading=>0.83101, :writing=>0.63942}}, :eighth_grade=>{2008=>{:math=>0.64, :reading=>0.843,
      :writing=>0.734}, 2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701}, 2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754}, 2011=>{:reading=>0.83221, :math=>0.65339, :writing=>0.74579}, 2012=>{:math=>0.68197, :writing=>0.73839, :reading=>0.83352},
      2013=>{:math=>0.6613, :reading=>0.85286, :writing=>0.75069}, 2014=>{:math=>0.68496, :reading=>0.827, :writing=>0.74789}}}
  end

  def test_it_has_a_class
    st = StatewideTest.new(@hash)
    assert_instance_of StatewideTest, st
  end

end
