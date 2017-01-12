require_relative 'test_helper'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test
  def test_it_has_a_class
    epr = EconomicProfileRepository.new
    assert_instance_of EconomicProfileRepository, epr
  end

  def test_it_displays_free_reduce_lunch_of_a_district
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"}})
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", ep.name
  end
end
