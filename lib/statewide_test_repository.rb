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

      #   subject = subject.downcase.to_sym
  def create_statewide_test_grade(name, sub_race, year, rate, grade, state_test)
    sub_race = sub_race.downcase.to_sym
    attributes = {:name => name, grade => {year =>{sub_race => rate}}}
    if state_test.nil?
      state_tests[name] = StatewideTest.new(attributes)
      # binding.pry
    elsif state_test.state_test_data[grade].nil?
      state_test.state_test_data[grade] = {year =>{sub_race => rate}}

    elsif state_test.state_test_data[grade][year].nil?
      state_test.state_test_data[grade][year] = {sub_race => rate}
    else
      state_test.state_test_data[grade][year].merge!({sub_race => rate})
      # binding.pry
      # add_data_to_state_test(name, sub_race, year, rate, grade, state_test)
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
      # binding.pry
      create_statewide_test_race(name, race, year, rate, grade, state_test)
    end
    binding.pry
  end

  def create_statewide_test_race(name, race, year, rate, grade, state_test)
    # binding.pry
    race = race.downcase.to_sym
    attributes = {:name => name, race => {year =>{grade => rate}}}
    if state_test.nil?
      state_tests[name] = StatewideTest.new(attributes)
      # binding.pry
    elsif state_test.state_test_data[race].nil?
      state_test.state_test_data[race] = {year =>{grade => rate}}

    elsif state_test.state_test_data[race][year].nil?
      state_test.state_test_data[race][year] = {grade => rate}
    else
      state_test.state_test_data[race][year].merge!({grade => rate})
      # binding.pry
      # add_data_to_state_test(name, sub_race, year, rate, grade, state_test)
    end
  end

  # def add_data_to_state_test(name, sub_race, year, rate, grade, state_test)
  #   if grade == :kindergarten_participation
  #     er.enrollment_data[:kindergarten_participation].merge!({year => rate})
  #   else
  #     er.enrollment_data[:high_school_graduation].merge!({year => rate})
  #   end
  # end
  # def add_data_to_state_test(name, sub_race, year, rate, grade, state_test)
  #   grade_3 = state_test.state_test_data[:third_grade]
  #   grade_8 = state_test.state_test_data[:eighth_grade]
  #   years = [2008,2009, 2010, 2011, 2012, 2013, 2014]
  #   years.each_with_index do |yr|
  #     if grade == :third_grade && year == yr && grade_3[yr].nil?
  #       grade_3[yr] = {subject => rate}
  #     elsif grade == :eighth_grade && year == yr && grade_8[yr].nil?
  #       grade_8[yr] = {subject => rate}
  #     elsif grade == :third_grade && year == yr && grade_3[yr].count != 0
  #       grade_3[yr].merge!({subject => rate})
  #     elsif grade == :eighth_grade && year == yr && grade_8[yr].count != 0
  #       grade_8[yr].merge!({subject => rate})
  #     end
  #   end
  # end

  def find_by_name(name)
    @state_tests[name.upcase]
  end
end
  # def distribution_scores(name, subject, year, rate, grade, state_test)
  #   if state_test == nil
  #     state_tests[name] = StatewideTest.new({:name => name, grade => {year =>{subject => rate}}})
  #   elsif grade == :eighth_grade && state_test.state_test_data[:eighth_grade].nil?
  #     state_test = state_tests[name]
  #     state_test.state_test_data[:eighth_grade] = {year =>{subject => rate}}
  #   # else
  #   #   add_years_rate_scores(state_test, grade, year, rate, subject)
  #   end
  # end


  # def add_race_keys_to_hash
  #   @races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  #   races.each do |race|
  #     state_test.state_test_data[race] = {}
  #   end
  # end
  #
  # def add_years_rate_scores_race(name, subject_race, race, year, rate, state_test)
  #   add_years_rate_scores_race
    # if @races[:asian]
    #
    # grade_3 = state_test.state_test_data[:third_grade]
    # grade_8 = state_test.state_test_data[:eighth_grade]
    # years = [2008,2009, 2010, 2011, 2012, 2013, 2014]
    #
    # years.each_with_index do |yr|
    #   if grade == :third_grade && year == yr && grade_3[yr].nil?
    #     grade_3[yr] = {subject => rate}
    #   elsif grade == :eighth_grade && year == yr && grade_8[yr].nil?
    #     grade_8[yr] = {subject => rate}
    #   elsif grade == :third_grade && year == yr && grade_3[yr].count != 0
    #     grade_3[yr].merge!({subject => rate})
    #   elsif grade == :eighth_grade && year == yr && grade_8[yr].count != 0
    #     grade_8[yr].merge!({subject => rate})
    #   end
    # end
  # end


    # {:asian => :asian,
                  # :black => :black,
                  # :pacific_islander => :pacific_islander,
                  # :hispanic => :hispanic,
                  # :native_american => :native_american,
                  # :two_or_more => :two_or_more,
                  # :white => :white}

    # def open_file_scores_by_race(data, filepath, index)
    #   CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
    #     name = row[:location].upcase
    #     race = row[:race_ethnicity]
    #     year = row[:timeframe].to_i
    #     rate = row[:data].to_f
    #     rate = 0 if rate == "NA" || rate == "N/A"
    #     subject = subjects[data.values[0].keys[index]]
    #     state_test = find_by_name(name)
    #     distribution_scores_race(name, subject, race, year, rate, state_test)
    #   end
    # end
