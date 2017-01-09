require_relative 'test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  def setup
    @er = EnrollmentRepository.new
    @er.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
  end

  def test_it_has_a_class
    assert_instance_of EnrollmentRepository, @er
  end

  def test_it_finds_district_when_known
    assert_equal Enrollment, @er.find_by_name("ACADEMY 20").class
  end

  def test_finder_is_case_insensitive
    assert_equal Enrollment, @er.find_by_name("academy 20").class
  end

  def test_it_gets_nil_if_district_unknown
    assert_nil @er.find_by_name("OHIO 216")
  end

  def test_it_adds_new_district_to_enrollment_data_tracker
    er = EnrollmentRepository.new
    er.add_to_enrollments("MOFFAT 2", 2004, 0.01429)

    assert_equal 1, er.enrollments.count
    assert_equal Enrollment, er.add_to_enrollments("MOFFAT 2", 2004, 0.01429).class
  end

  def test_it_adds_new_data_to_existant_district_in_data_tracker
    er = EnrollmentRepository.new
    er.add_to_enrollments("CENTENNIAL R-1", 2005, 0.10526)
    er.add_to_enrollments("CENTENNIAL R-1", 2006, 04545)
    expected = {:name=>"CENTENNIAL R-1", :kindergarten_participation=>{2005=>0.10526, 2006=>2405}, :high_school_graduation=>{}}

    assert_equal 1, er.enrollments.count
    assert_equal expected, er.enrollments["CENTENNIAL R-1"].enrollment_data
  end

  def test_it_access_name
    name = "GUNNISON WATERSHED RE1J"
    enrollment = @er.find_by_name(name)
    assert_equal name, enrollment.name
  end

  def test_it_loads_a_second_data_file
    enrollment = @er.find_by_name("ACADEMY 20")
    assert_equal 0.895, enrollment.enrollment_data[:high_school_graduation][2010]
  end
end