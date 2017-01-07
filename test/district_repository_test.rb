require './test/test_helper'
require './lib/district_repository'
#change to require_relative for spec harness

class DistrictRepositoryTest < Minitest::Test

  # def test_it_has_a_class
  #   dr = DistrictRepository.new
  #   assert_instance_of DistrictRepository, dr
  # end
  #
  # #maybe test file loads? #Mocha test??
  #
  def test_it_displays_district_if_known
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }})

    assert_equal "ACADEMY 20", dr.find_by_name("ACADEMY 20").district_info[:name]
  end
  #
  # def test_it_is_case_insensitive
  #   dr = DistrictRepository.new
  #   dr.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv"
  #     }})
  #   assert_equal District, dr.find_by_name("adams county 14").class
  # end
  #
  # def test_it_gets_nil_if_district_unknown
  #   dr = DistrictRepository.new
  #   dr.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv"
  #     }})
  #   assert_nil dr.find_by_name("ARIZONA")
  # end
  #
  def test_it_finds_district_from_name_fragment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }})

    assert_equal ["CALHAN RJ-1", "CAMPO RE-6", "CANON CITY RE-1"], dr.find_all_matching("ca")
  end
  #
  # def test_it_finds_all_matches_for_a_name_fragment
  #   dr = DistrictRepository.new
  #   dr.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv"
  #     }})
  #   assert_equal ["AGATE 300", "AGUILAR REORGANIZED 6"], dr.find_all_matching("AG")
  # end
  #
  # def test_it_finds_district_from_name_fragment_is_insensitive
  #   dr = DistrictRepository.new
  #   dr.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv"
  #       }})
  #   assert_equal ["ARCHULETA COUNTY 50 JT"], dr.find_all_matching("arch")
  # end
end
