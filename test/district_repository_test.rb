require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def test_it_has_a_class
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end

  #maybe test file loads?

  def test_it_displays_district_if_known
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }})
    assert_equal District, dr.find_by_name("ACADEMY 20").class
  end

  def test_finds_is_case_insensitive
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }})
    assert_equal District, dr.find_by_name("adams county 14").class
  end

  def test_it_gets_nil_if_district_unknown
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }})
    assert_equal nil, dr.find_by_name("ARIZONA")
  end

  def test_it_can_look_for_district_name_fragments
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }})
    assert_equal "ADAMS COUNTY 14", dr.find_all_matching("ada")
  end

end
