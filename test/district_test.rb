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
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    d = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", d.enrollment.name
  end

end
