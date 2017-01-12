require_relative 'test_helper'
require './lib/economic_profile'

class EconomicProfileTest < Minitest::Test
  def test_it_has_a_class
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    ep = EconomicProfile.new(data)
    assert_instance_of EconomicProfile, ep
  end

  def test_it_extracts_median_household_income_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
          :children_in_poverty => {2012 => 0.1845},
          :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
          :title_i => {2015 => 0.543},
          :name => "ACADEMY 20"}

    ep = EconomicProfile.new(data)
    assert_equal 50000, ep.median_household_income_in_year(2005)
  end

  def test_it_extracts_median_household_income_average
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
          :children_in_poverty => {2012 => 0.1845},
          :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
          :title_i => {2015 => 0.543},
          :name => "ACADEMY 20"}

    ep = EconomicProfile.new(data)
    assert_equal 55000, ep.median_household_income_average
  end

  def test_it_extracts_children_in_poverty_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    ep = EconomicProfile.new(data)
    assert_equal 0.184, ep.children_in_poverty_in_year(2012)
  end

  def test_it_extracts_free_or_reduced_price_lunch_percentage_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    ep = EconomicProfile.new(data)
    assert_equal 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_it_extracts_free_or_reduced_price_lunch_number_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    ep = EconomicProfile.new(data)
    assert_equal 100, ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_it_extracts_title_i_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    ep = EconomicProfile.new(data)
    assert_equal 0.543, ep.title_i_in_year(2015)
  end

  def test_it_raises_an_error
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "ACADEMY 20"}

    ep = EconomicProfile.new(data)

    assert_raises(UnknownDataError) do
      ep.children_in_poverty_in_year(2018)
    end

    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_percentage_in_year(3002)
    end
  end
end
