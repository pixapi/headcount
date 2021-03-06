require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/small_kindergartners_full_day.csv"}})
  end

  def test_it_has_a_class
    assert_instance_of DistrictRepository, @dr
  end

  def test_it_displays_district_if_known
    assert_equal "ACADEMY 20", @dr.find_by_name("ACADEMY 20").district_info[:name]
  end

  def test_it_displays_district_if_known
    assert_equal "ADAMS COUNTY 14", @dr.find_by_name("adams county 14").district_info[:name]
  end

  def test_it_gets_nil_if_district_unknown
    assert_nil @dr.find_by_name("ARIZONA")
  end

  def test_it_finds_all_matches_for_a_name_fragment
    assert_equal ["ALAMOSA RE-11J"], @dr.find_all_matching("AL")
  end

  def test_it_finds_district_from_name_fragment
    assert_equal ["CALHAN RJ-1", "CAMPO RE-6", "CANON CITY RE-1"], @dr.find_all_matching("CA")
  end

  def test_it_finds_district_from_name_fragment_is_insensitive
    assert_equal ["ARCHULETA COUNTY 50 JT"], @dr.find_all_matching("arc")
  end

  def test_it_finds_district_from_name_fragment_is_insensitive
    assert_equal ["ARCHULETA COUNTY 50 JT"], @dr.find_all_matching("arc")
  end

  def test_it_finds_enrollment_for_a_district
    assert_equal "COLORADO", @dr.find_enrollment("Colorado").name
    assert_equal Enrollment, @dr.find_enrollment("Colorado").class
  end
end
