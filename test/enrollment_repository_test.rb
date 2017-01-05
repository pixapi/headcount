require_relative 'test_helper'
require './lib/enrollment_repository'
#change to require_relative for spec harness?

class EnrollmentRepositoryTest < Minitest::Test
  def test_it_has_a_class
    er = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, er
  end

  def test_it_displays_enrollment_if_known
    er = EnrollmentRepository.new
    # See if we can put load_data method in def set up
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    assert_equal Enrollment, enrollment.class
  end

  def test_it_is_case_insensitive
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    enrollment = er.find_by_name("academy 20")
    assert_equal Enrollment, enrollment.class
  end

  def test_it_gets_nil_if_district_unknown
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    enrollment = er.find_by_name("OHIO 216")
    assert_nil enrollment
  end

  # def test_it_finds_district_when_valid
  #   er = EnrollmentRepository.new
  #   # found_district = [<CSV::Row location:"ACADEMY 20" timeframe:"2007" dataformat:"Percent" data:"0.39159">]
  #   assert_equal CSV, er.determine_district_validity(found_district, "ARCHULETA COUNTY 50").class
  #   #assert_equal "ACADEMY 20", er.determine_district_validity(found_district, "ARCHULETA COUNTY 50")[:location]
  # end

  # def test_it_collects_enrollment_data
  #   skip
  #   er = EnrollmentRepository.new
  #   # found_district = [<CSV::Row location:"ACADEMY 20" timeframe:"2007" dataformat:"Percent" data:"0.39159">]
  #   assert_equal CSV, er.build_enrollment_data(found_district).class
  # end

  # def test_it_creates_enrollment_instance
  #   skip
  #   er = EnrollmentRepository.new
  #   # found_district = [<CSV::Row location:"ACADEMY 20" timeframe:"2007" dataformat:"Percent" data:"0.39159">]
  #   assert_equal CSV, er.create_enrollment_instance(found_district, year_rate).class
  #   #assert_equal "ACADEMY 20", er.determine_district_validity(found_district, "ARCHULETA COUNTY 50")[:location]
  # end
  def test_it_returns_nil_when_invalid_district
    er = EnrollmentRepository.new
    expected = er.determine_district_validity([], "ARCHULETA COUNTY 50")
    assert_nil expected
  end
end
