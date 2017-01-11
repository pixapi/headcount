require './test/test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repository'

class StatewideTestTest < Minitest::Test
  def setup
    @hash = {:name=>"ACADEMY 20", :third_grade=>{2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}, 2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662}, 2011=>{:math=>0.819, :reading=>0.867,
      :writing=>0.678}, 2012=>{:reading=>0.87, :math=>0.83, :writing=>0.65517}, 2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687}, 2014=>{:math=>0.8345, :reading=>0.83101, :writing=>0.63942}}, :eighth_grade=>{2008=>{:math=>0.64, :reading=>0.843,
      :writing=>0.734}, 2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701}, 2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754}, 2011=>{:reading=>0.83221, :math=>0.65339, :writing=>0.74579}, 2012=>{:math=>0.68197, :writing=>0.73839, :reading=>0.83352},
      2013=>{:math=>0.6613, :reading=>0.85286, :writing=>0.75069}, 2014=>{:math=>0.68496, :reading=>0.827, :writing=>0.74789}}}
  end

  def test_it_has_a_class
    st = StatewideTest.new(@hash)
    assert_instance_of StatewideTest, st
  end

  def test_it_extracts_state_wide_proficiency_data
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }})

    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                 2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                 2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                 2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                 2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                 2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                 2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}}

    testing = str.find_by_name("ACADEMY 20")
    expected.each do |year, data|
      data.each do |subject, proficiency|
        assert_in_delta proficiency, testing.proficient_by_grade(3)[year][subject], 0.005
      end
    end

  #   expected.each do |year, data|
  #     data.each do |subject, proficiency|
  #       assert_in_delta proficiency, testing.proficient_by_grade(6)[year][subject], 0.005
  #     end
  #   end
  end
  # MAYBE BUILD A TEST TO PROVE THAT NEXT TEST SHOWS UNKNOWN WHEN RACE NOT FOUND #####

  def test_finds_scores_during_years_by_race
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }})
    testing = str.find_by_name("WOODLAND PARK RE-2")

    expected = {2011=>{:math=>0.451, :reading=>0.688, :writing=>0.503},
                2012=>{:math=>0.467, :reading=>0.75, :writing=>0.528},
                2013=>{:math=>0.473, :reading=>0.738, :writing=>0.531},
                2014=>{:math=>0.418, :reading=>0.006, :writing=>0.453}}

    result = testing.proficient_by_race_or_ethnicity(:hispanic)
    expected.each do |year, data|
      data.each do |subject, proficiency|
        assert_in_delta proficiency, result[year][subject], 0.005
      end
    end
  end

  def test_finds_score_per_subject_year_subject
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }})

    testing = str.find_by_name("WRAY SCHOOL DISTRICT RD-2")
    assert_in_delta 0.89, testing.proficient_for_subject_by_grade_in_year(:reading, 3, 2014), 0.005

    # testing = str.find_by_name("PLATEAU VALLEY 50")
    # assert_equal "N/A", testing.proficient_for_subject_by_grade_in_year(:reading, 8, 2011)
  end

  def test_finds_score_per_race_year_subject
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }})

    testing = str.find_by_name("BUFFALO RE-4")
    assert_in_delta 0.65, testing.proficient_for_subject_by_race_in_year(:math, :white, 2012), 0.005
    assert_in_delta 0.437, testing.proficient_for_subject_by_race_in_year(:math, :hispanic, 2014), 0.005
    assert_in_delta 0.76, testing.proficient_for_subject_by_race_in_year(:reading, :white, 2013), 0.005
    assert_in_delta 0.375, testing.proficient_for_subject_by_race_in_year(:writing, :hispanic, 2014), 0.005
  end

  def test_unknown_data_errors
    #CHECK IF PASSES ONCE RAISE ERROR SET IN OUR STATEWIDE_TEST.RB

    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }})
    testing = str.find_by_name("AULT-HIGHLAND RE-9")

    assert_raises(UnknownDataError) do
      testing.proficient_by_grade(1)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_grade_in_year(:pizza, 8, 2011)
    end

    # assert_raises(UnknownDataError) do
    #   testing.proficient_for_subject_by_race_in_year(:reading, :pizza, 2013)
    # end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_race_in_year(:pizza, :white, 2013)
    end
  end


end
