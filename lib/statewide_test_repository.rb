require 'csv'
require_relative 'statewide_test'
require 'pry'

class StatewideTestRepository
  attr_reader :grade_levels,
              :state_tests
  def initialize
    @state_tests = {}
    @grade_levels = {:third_grade => :third_grade,
                     :eighth_grade => :eighth_grade}
    @subjects = { :math => :math,
                  :reading => :reading,
                  :writing => :writing}
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
      open_file_scores(data, filepath, index)
    end
  end

  def open_file_scores(data, filepath, index)
    CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      subject = row[:score]
      year = row[:timeframe].to_i
      rate = row[:data].to_f
        rate = 0 if rate == "NA" || rate == "N/A"
      grade = grade_levels[data.values[0].keys[index]]
      state_test = find_by_name(name)
      distribution_scores(name, subject, year, rate, grade, state_test)
    end
  end

    def distribution_scores(name, subject, year, rate, grade, state_test)
      if state_test == nil
        state_tests[name] = StatewideTest.new({:name => name, grade => {subject =>{year => rate}}})
      elsif grade == :eighth_grade && state_test.state_test_data[:eighth_grade].nil?
        state_test = state_tests[name]
        state_test.state_test_data[:eighth_grade] = {subject =>{year => rate}}
      else
        add_years_rate_scores(state_test, grade, year, rate, subject)
      end
    end

    def add_years_rate_scores(state_test, grade, year, rate, subject)
      grade_3 = state_test.state_test_data[:third_grade]
      grade_8 = state_test.state_test_data[:eighth_grade]
      if grade == :third_grade && subject == "Math" && grade_3["Math"].nil?
        grade_3["Math"] = {year => rate}
      elsif grade == :third_grade && subject == "Math" && grade_3["Math"].count != 0
        grade_3["Math"].merge!({year => rate})
      elsif grade == :third_grade && subject == "Reading" && grade_3["Reading"].nil?
        grade_3["Reading"] = {year => rate}
      elsif grade == :third_grade && subject == "Reading" && grade_3["Reading"].count != 0
        grade_3["Reading"].merge!({year => rate})
      elsif grade == :third_grade && subject == "Writing" && grade_3["Writing"].nil?
        grade_3["Writing"] = {year => rate}
      elsif grade == :third_grade && subject == "Writing" && grade_3["Writing"].count != 0
        grade_3["Writing"].merge!({year => rate})
      elsif grade == :eighth_grade && subject == "Math" && grade_8["Math"].nil?
        grade_8["Math"] = {year => rate}
      elsif grade == :eighth_grade && subject == "Math" && grade_8["Math"].count != 0
        grade_8["Math"].merge!({year => rate})
      elsif grade == :eighth_grade && subject == "Reading" && grade_8["Reading"].nil?
        grade_8["Reading"] = {year => rate}
      elsif grade == :eighth_grade && subject == "Reading" && grade_8["Reading"].count != 0
        grade_8["Reading"].merge!({year => rate})
      elsif grade == :eighth_grade && subject == "Writing" &&  grade_8["Writing"].nil?
        grade_8["Writing"] = {year => rate}
      elsif grade == :eighth_grade && subject == "Writing" &&  grade_8["Writing"].count != 0
        grade_8["Writing"].merge!({year => rate})
      end
    end

    def find_by_name(name)
      @state_tests[name.upcase]
    end

    # def open_file_scores_by_race(data, filepath, index)
    #   CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
    #     name = row[:location].upcase
    #     race = row[:race]
    #     year = row[:timeframe].to_i
    #     rate = row[:data].to_f
    #     rate = 0 if rate == "NA" || rate == "N/A"
    #     grade = grade_levels[data.values[0].keys[index]]
    #     state_test = find_by_name(name)
    #     distribution(name, race, year, rate, state_test)
    #   end
    # end
end