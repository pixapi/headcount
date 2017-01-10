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
        binding.pry
      elsif grade == :eighth_grade && state_test.state_test_data[:eighth_grade].nil?
        state_test = state_tests[name]
        state_test.state_test_data[:eighth_grade] = {year => rate}
      elsif grade == :eighth_grade && state_test.state_test_data[:eighth_grade].count != 0
        add_years_rate_scores(state_test, grade, year, rate)
      else
        add_years_rate_scores(state_test, grade, year, rate)
      end
    end

    def add_years_rate_scores(state_test, grade, year, rate)
      if grade == :third_grade
        state_test.state_test_data[:third_grade].merge!({year => rate})
      elsif grade == :eighth_grade
        state_test.state_test_data[:eighth_grade].merge!({year => rate})
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
#
# str = StatewideTestRepository.new
# str.load_data({:statewide_testing => {
# :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
# :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
# :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
# :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
# :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
# }})
# str.find_by_name("Colorado")
