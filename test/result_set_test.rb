require_relative 'test_helper'
require './lib/result_set'
require './lib/result_entry'
require './lib/headcount_analyst'

class ResultSetTest < Minitest::Test
  def test_class_exists
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)
    assert_instance_of ResultSet, rs
  end

  def test_it_returns_entry_rates
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75,
    median_household_income: 55483})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6,
    median_household_income: 98540})

    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    assert_equal 0.5, rs.matching_districts.first.free_and_reduced_price_lunch_rate
    assert_equal 0.3, rs.statewide_average.free_and_reduced_price_lunch_rate

    assert_equal 0.25, rs.matching_districts.first.children_in_poverty_rate
    assert_equal 0.2, rs.statewide_average.children_in_poverty_rate

    assert_equal 0.75, rs.matching_districts.first.high_school_graduation_rate
    assert_equal 0.6, rs.statewide_average.high_school_graduation_rate

    assert_equal 55483, rs.matching_districts.first.median_household_income
    assert_equal 98540, rs.statewide_average.median_household_income
  end
end
