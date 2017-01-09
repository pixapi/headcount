require_relative 'test_helper'
require './lib/enrollment'
#change to require_relative for spec harness

class EnrollmentTest < Minitest::Test
  def test_it_has_a_class
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_instance_of Enrollment, e
  end

  def test_it_returns_years_and_participation
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    enrollment = { 2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    assert_equal enrollment, e.kindergarten_participation_by_year
  end

  def test_it_returns_years_and_participation
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

  def test_it_returns_graduation_by_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
      :high_school_graduation => { 2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}})
    graduation = { 2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}
    assert_equal graduation, e.graduation_rate_by_year
  end

  def test_it_returns_graduation_in_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
      :high_school_graduation => { 2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}})
    assert_equal 0.895, e.graduation_rate_in_year(2010)
  end
end
