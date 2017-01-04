require_relative 'test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  def test_it_has_a_class
    er = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, er
  end

  def test_it_displays_enrollment_if_known
    er = EnrollmentRepository.new
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
    skip
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    enrollment = er.find_by_name("OHIO 216")
    assert_equal nil, enrollment
  end

end
