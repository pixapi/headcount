require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test
  def test_it_has_a_class
    str = StatewideTestRepository.new
    assert_instance_of StatewideTestRepository, str
  end

  def test_it_loads_all_files
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }})
    str = str.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", str
  end
end
