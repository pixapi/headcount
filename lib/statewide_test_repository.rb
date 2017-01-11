require 'csv'
require_relative 'statewide_test'
require 'pry'

class StatewideTestRepository
  attr_reader :grade_levels,
              :state_tests

  def initialize
    @state_tests = {}
    @grade_levels = {
      :third_grade => :third_grade,
      :eighth_grade => :eighth_grade,
      "ALL STUDENTS" => :all_students,
      "ASIAN" => :asian,
      "BLACK" => :black,
      "PACIFIC ISLANDER" => :pacific_islander,
      "HISPANIC" => :hispanic,
      "NATIVE AMERICAN" => :native_american,
      "TWO OR MORE" => :two_or_more,
      "WHITE" => :white}

  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
      if filepath.include?("grade")
        extract_grade_file(data, filepath, index)
      else
        extract_race_file(data, filepath, index)
      end
    end
  end

  def extract_grade_file(data, filepath, index)
    CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      subject = row[:score]
      year = row[:timeframe].to_i
      rate = row[:data].to_f
      rate = 0 if rate == "NA" || rate == "N/A" || rate == "LNE"
      grade = grade_levels[data.values[0].keys[index]]
      state_test = find_by_name(name)
      create_statewide_test_grade(name, subject, year, rate, grade, state_test)
    end
  end

  def create_statewide_test_grade(name, sub_race, year, rate, grade, state_test)
    sub_race = sub_race.downcase.to_sym
    attributes = {:name => name, grade => {year =>{sub_race => rate}}}
    if state_test.nil?
      state_tests[name] = StatewideTest.new(attributes)
    elsif state_test.state_test_data[grade].nil?
      state_test.state_test_data[grade] = {year =>{sub_race => rate}}

    elsif state_test.state_test_data[grade][year].nil?
      state_test.state_test_data[grade][year] = {sub_race => rate}
    else
      state_test.state_test_data[grade][year].merge!({sub_race => rate})
    end
  end

  def extract_race_file(data, filepath, index)
    CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      race = row[:race_ethnicity]
      year = row[:timeframe].to_i
      rate = row[:data].to_f
      rate = 0 if rate == "NA" || rate == "N/A" || rate == "LNE"
      grade = data.values[0].keys[index]
      state_test = find_by_name(name)
      create_statewide_test_race(name, race, year, rate, grade, state_test)
    end
  end

  def create_statewide_test_race(name, race, year, rate, grade, state_test)
    race = race.downcase.to_sym
    attributes = {:name => name, race => {year =>{grade => rate}}}
    if state_test.nil?
      state_tests[name] = StatewideTest.new(attributes)
    elsif state_test.state_test_data[race].nil?
      state_test.state_test_data[race] = {year =>{grade => rate}}
    elsif state_test.state_test_data[race][year].nil?
      state_test.state_test_data[race][year] = {grade => rate}
    else
      state_test.state_test_data[race][year].merge!({grade => rate})
    end
  end

  def find_by_name(name)
    @state_tests[name.upcase]
  end
end
