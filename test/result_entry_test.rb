require_relative 'test_helper'
require './lib/result_entry'

class ResultEntryTest < Minitest::Test
  def test_class_exists
    re = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
    assert_instance_of ResultEntry, re
  end
end