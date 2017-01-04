require_relative 'test_helper'
require './lib/district'

class DistrictTest < Minitest::Test
  def test_it_has_a_class
    d = District.new({:name => "ACADEMY 20"})
    assert_instance_of District, d
  end

  def test_it_returns_name_string
    d = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", d.name
  end

  def test_it_returns_name_string_in_all_caps
    d = District.new({:name => "academy 20"})
    assert_equal "ACADEMY 20", d.name
  end

end
