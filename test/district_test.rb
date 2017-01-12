require_relative 'test_helper'
require './lib/district'
require './lib/district_repository'

class DistrictTest < Minitest::Test
  # def test_it_has_a_class
  #   d = District.new({:name => "ACADEMY 20"}, self)
  #   assert_instance_of District, d
  # end
  #
  # def test_it_returns_name_string
  #   d = District.new({:name => "ACADEMY 20"}, self)
  #   assert_equal "ACADEMY 20", d.name
  # end
  #
  # def test_it_returns_name_string_in_all_caps
  #   d = District.new({:name => "academy 20"}, self)
  #   assert_equal "ACADEMY 20", d.name
  # end

  # def test_it_gets_instance_of_enrollment
  #   dr = DistrictRepository.new
  #   dr.load_data({
  #     :enrollment => {
  #     :kindergarten => "./data/Kindergartners in full-day program.csv"
  #     }
  #   })
  #   d = dr.find_by_name("ACADEMY 20")
  #   assert_equal "ACADEMY 20", d.enrollment.name
  # end

  def test_connection_district_statewide_test
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    statewide_test = district.statewide_test
  end

  # def test_connection_district_economic_profile
  #   dr = DistrictRepository.new
  #   dr.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv",
  #       :high_school_graduation => "./data/High school graduation rates.csv",
  #     },
  #     :economic_profile => {
  #     :median_household_income => "./data/Median household income.csv",
  #     :children_in_poverty => "./data/School-aged children in poverty.csv",
  #     :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
  #     :title_i => "./data/Title I students.csv"}})
  #   district = dr.find_by_name("ACADEMY 20")
  #   economic_profile = district.economic_profile
  # end

end
