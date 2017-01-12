require_relative 'test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  def test_it_has_a_class
    er = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, er
  end

  def test_it_finds_district_when_known
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    assert_equal Enrollment, er.find_by_name("ACADEMY 20").class
  end

  def test_finder_is_case_insensitive
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    assert_equal Enrollment, er.find_by_name("academy 20").class
  end

  def test_it_gets_nil_if_district_unknown
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    assert_nil er.find_by_name("OHIO 216")
  end
  
  def test_it_can_acces_name
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"}})
    name = "GUNNISON WATERSHED RE1J"
    enrollment = er.find_by_name(name)
    assert_equal name, enrollment.name
  end

  def test_it_can_load_a_second_file
    er = EnrollmentRepository.new
    er.load_data({:enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"}})
    enrollment = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", enrollment.name
  end
end
