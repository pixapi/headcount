require_relative 'test_helper'
require './lib/district'
require './lib/district_repository'

class DistrictTest < Minitest::Test
  def test_it_has_a_class
    d = District.new({:name => "ACADEMY 20"}, self)
    assert_instance_of District, d
  end

  def test_it_returns_name_string
    d = District.new({:name => "ACADEMY 20"}, self)
    assert_equal "ACADEMY 20", d.name
  end

  def test_it_returns_name_string_in_all_caps
    d = District.new({:name => "academy 20"}, self)
    assert_equal "ACADEMY 20", d.name
  end

  def test_it_gets_instance_of_enrollment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
      :kindergarten => "./test/fixtures/small_kindergartners_full_day.csv"
      }
    })
    d = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", d.enrollment.name
  end

  def test_connection_district_statewide_test
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/small_kindergartners_full_day.csv",
        :high_school_graduation => "./test/fixtures/small_high_school_graduation.csv",
      },
      :statewide_testing => {
        :third_grade => "./test/fixtures/small_third_grade.csv",
        :eighth_grade => "./test/fixtures/small_eighth_grade.csv",
        :math => "./test/fixtures/small_math_by_race.csv",
        :reading => "./test/fixtures/small_reading_by_race.csv",
        :writing => "./test/fixtures/small_writing_by_race.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    statewide_test = district.statewide_test
  end

  def test_connection_district_economic_profile
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/small_kindergartners_full_day.csv",
        :high_school_graduation => "./test/fixtures/small_high_school_graduation.csv",
      },
      :economic_profile => {
      :median_household_income => "./test/fixtures/small_median_household_income.csv",
      :children_in_poverty => "./test/fixtures/small_children_in_poverty.csv",
      :free_or_reduced_price_lunch => "./test/fixtures/small_free_reduce_lunch.csv",
      :title_i => "./test/fixtures/small_title_i.csv"}})
    district = dr.find_by_name("ACADEMY 20")
    economic_profile = district.economic_profile
  end

end
