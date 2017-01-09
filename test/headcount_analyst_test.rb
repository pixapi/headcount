require_relative 'test_helper'
require './lib/headcount_analyst'
require './lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new
    @e = HeadcountAnalyst.new(@dr)
    @dr.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
  end

  def test_it_has_a_class
    assert_instance_of HeadcountAnalyst, @e
  end

  def test_it_gets_participation_variation_district_vs_state
    assert_equal 0.766, @e.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_it_gets_participation_variation_district_vs_district
    assert_in_delta 0.447, @e.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1'), 0.005
  end

  def test_calculate_average
    assert_equal 0.7088181818181819, @e.calculate_average("ADAMS COUNTY 14")
  end

  def test_it_gets_participation_variation_district_vs_district
    result = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652,
      2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }.values[0]
    assert_in_delta result, @e.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'Colorado').values[0], 0.005
  end
end
