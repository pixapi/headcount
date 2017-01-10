require_relative 'test_helper'
require './lib/headcount_analyst'
require './lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  def test_it_has_a_class
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    assert_instance_of HeadcountAnalyst, ha
  end

  def test_it_gets_participation_variation_district_vs_state
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_it_gets_participation_variation_district_vs_state_ignoring_corrupted_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"}})
        ha = HeadcountAnalyst.new(dr)
        assert_equal 0.0, ha.kindergarten_participation_rate_variation('WEST YUMA COUNTY RJ-1', :against => 'COLORADO')
      end

  def test_it_gets_participation_variation_district_vs_district
    dr = DistrictRepository.new
    dr.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.446, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
  end

  def test_calculate_average
    dr = DistrictRepository.new
    dr.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.7088181818181819, ha.calculate_average("ADAMS COUNTY 14")
  end

  def test_it_gets_participation_variation_district_vs_district
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    result = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652,
      2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
    result.each do |year, rate|
      assert_in_delta rate, ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'Colorado')[year], 0.005
    end
  end

  def test_it_compares_variations_of_kindergarten_participation_with_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.800, ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2')
    assert_equal 0.548, ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J')
  end

  def test_it_compares_variations_of_kindergarten_participation_with_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }})
    ha = HeadcountAnalyst.new(dr)
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_it_compares_variations_of_kindergarten_participation_with_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }})
    ha = HeadcountAnalyst.new(dr)
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end
end
