require 'csv'
require_relative 'statewide_test'
require 'pry'

class StatewideTestRepository
  attr_reader :grade_levels,
              :state_tests,
              :subjects_race
  def initialize
    @state_tests = {}
    @grade_levels = {:third_grade => :third_grade,
                     :eighth_grade => :eighth_grade}
    @subjects_race = {:math => :math,
                      :reading => :reading,
                      :writing => :writing}
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
      open_file_scores(data, filepath, index)
    end
    # data.values[0].values.each_with_index do |filepath, index|
    #   open_file_scores_by_race(data, filepath, index)
    # end
  end

  def open_file_scores(data, filepath, index)
    CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      race = row[:race_ethnicity]
      subject = row[:score]
      year = row[:timeframe].to_i
      rate = row[:data].to_f
      rate = 0 if rate == "NA" || rate == "N/A" || rate == "LNE"
      grade = grade_levels[data.values[0].keys[index]]
      subject_race = subjects_race[data.values[0].keys[index]]
      state_test = find_by_name(name)
      if row[:race_ethnicity].nil?
        subject = subject.downcase.to_sym
        distribution_scores(name, subject, year, rate, grade, state_test)
      # else
      #   add_years_rate_scores_race(name, subject_race, race, year, rate, state_test)
      end
    end
  end


    def distribution_scores(name, subject, year, rate, grade, state_test)
      if state_test == nil
        state_tests[name] = StatewideTest.new({:name => name, grade => {year =>{subject => rate}}})
      elsif grade == :eighth_grade && state_test.state_test_data[:eighth_grade].nil?
        state_test = state_tests[name]
        state_test.state_test_data[:eighth_grade] = {year =>{subject => rate}}
      else
        add_years_rate_scores(state_test, grade, year, rate, subject)
      end
    end

    # def add_years_rate_scores(state_test, grade, year, rate, subject)
    #   grade_3 = state_test.state_test_data[:third_grade]
    #   grade_8 = state_test.state_test_data[:eighth_grade]
    #   if grade == :third_grade && subject == "Math" && grade_3["Math"].nil?
    #     grade_3["Math"] = {year => rate}
    #   elsif grade == :third_grade && subject == "Math" && grade_3["Math"].count != 0
    #     grade_3["Math"].merge!({year => rate})
    #   elsif grade == :third_grade && subject == "Reading" && grade_3["Reading"].nil?
    #     grade_3["Reading"] = {year => rate}
    #   elsif grade == :third_grade && subject == "Reading" && grade_3["Reading"].count != 0
    #     grade_3["Reading"].merge!({year => rate})
    #   elsif grade == :third_grade && subject == "Writing" && grade_3["Writing"].nil?
    #     grade_3["Writing"] = {year => rate}
    #   elsif grade == :third_grade && subject == "Writing" && grade_3["Writing"].count != 0
    #     grade_3["Writing"].merge!({year => rate})
    #   elsif grade == :eighth_grade && subject == "Math" && grade_8["Math"].nil?
    #     grade_8["Math"] = {year => rate}
    #   elsif grade == :eighth_grade && subject == "Math" && grade_8["Math"].count != 0
    #     grade_8["Math"].merge!({year => rate})
    #   elsif grade == :eighth_grade && subject == "Reading" && grade_8["Reading"].nil?
    #     grade_8["Reading"] = {year => rate}
    #   elsif grade == :eighth_grade && subject == "Reading" && grade_8["Reading"].count != 0
    #     grade_8["Reading"].merge!({year => rate})
    #   elsif grade == :eighth_grade && subject == "Writing" &&  grade_8["Writing"].nil?
    #     grade_8["Writing"] = {year => rate}
    #   elsif grade == :eighth_grade && subject == "Writing" &&  grade_8["Writing"].count != 0
    #     grade_8["Writing"].merge!({year => rate})
    #   end
    # end

#################################################################################################################
def add_years_rate_scores(state_test, grade, year, rate, subject)
      grade_3 = state_test.state_test_data[:third_grade]
      grade_8 = state_test.state_test_data[:eighth_grade]
      if grade == :third_grade && year == 2008 && grade_3[2008].nil?
        grade_3[2008] = {subject => rate}
      elsif grade == :third_grade && year == 2008 && grade_3[2008].count != 0
        grade_3[2008].merge!({subject => rate})
      elsif grade == :third_grade && year == 2009 && grade_3[2009].nil?
        grade_3[2009] = {subject => rate}
      elsif grade == :third_grade && year == 2009 && grade_3[2009].count != 0
        grade_3[2009].merge!({subject => rate})
      elsif grade == :third_grade && year == 2010 && grade_3[2010].nil?
        grade_3[2010] = {subject => rate}
      elsif grade == :third_grade && year == 2010 && grade_3[2010].count != 0
        grade_3[2010].merge!({subject => rate})
      elsif grade == :third_grade && year == 2011 && grade_3[2011].nil?
        grade_3[2011] = {subject => rate}
      elsif grade == :third_grade && year == 2011 && grade_3[2011].count != 0
        grade_3[2011].merge!({subject => rate})
      elsif grade == :third_grade && year == 2012 && grade_3[2012].nil?
        grade_3[2012] = {subject => rate}
      elsif grade == :third_grade && year == 2012 && grade_3[2012].count != 0
        grade_3[2012].merge!({subject => rate})
      elsif grade == :third_grade && year == 2013 && grade_3[2013].nil?
        grade_3[2013] = {subject => rate}
      elsif grade == :third_grade && year == 2013 && grade_3[2013].count != 0
        grade_3[2013].merge!({subject => rate})
      elsif grade == :third_grade && year == 2014 && grade_3[2014].nil?
        grade_3[2014] = {subject => rate}
      elsif grade == :third_grade && year == 2014 && grade_3[2014].count != 0
        grade_3[2014].merge!({subject => rate})
        ########################
      elsif grade == :eighth_grade && year == 2008 && grade_8[2008].nil?
        grade_8[2008] = {subject => rate}
      elsif grade == :eighth_grade && year == 2008 && grade_8[2008].count != 0
        grade_8[2008].merge!({subject => rate})
      elsif grade == :eighth_grade && year == 2009 && grade_8[2009].nil?
        grade_8[2009] = {subject => rate}
      elsif grade == :eighth_grade && year == 2009 && grade_8[2009].count != 0
        grade_8[2009].merge!({subject => rate})
      elsif grade == :eighth_grade && year == 2010 && grade_8[2010].nil?
        grade_8[2010] = {subject => rate}
      elsif grade == :eighth_grade && year == 2010 && grade_8[2010].count != 0
        grade_8[2010].merge!({subject => rate})
      elsif grade == :eighth_grade && year == 2011 && grade_8[2011].nil?
        grade_8[2011] = {subject => rate}
      elsif grade == :eighth_grade && year == 2011 && grade_8[2011].count != 0
        grade_8[2011].merge!({subject => rate})
      elsif grade == :eighth_grade && year == 2012 && grade_8[2012].nil?
        grade_8[2012] = {subject => rate}
      elsif grade == :eighth_grade && year == 2012 && grade_8[2012].count != 0
        grade_8[2012].merge!({subject => rate})
      elsif grade == :eighth_grade && year == 2013 && grade_8[2013].nil?
        grade_8[2013] = {subject => rate}
      elsif grade == :eighth_grade && year == 2013 && grade_8[2013].count != 0
        grade_8[2013].merge!({subject => rate})
      elsif grade == :eighth_grade && year == 2014 && grade_8[2014].nil?
        grade_8[2014] = {subject => rate}
      elsif grade == :eighth_grade && year == 2014 && grade_8[2014].count != 0
        grade_8[2014].merge!({subject => rate})
      end
    end
#################################################################################################################

    def find_by_name(name)
      @state_tests[name.upcase]
    end
##############################################
    
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

    # def distribution_scores_race(name, subject_race, race, year, rate, state_test)
    #   if subject == #:eighth_grade && state_test.state_test_data[:eighth_grade].nil?
    #     state_test = state_tests[name]
    #     state_test.state_test_data#[:eighth_grade] = #{subject =>{year => rate}}
    #   else
    #     add_years_rate_scores_race(state_test, subject, year, rate)
    #   end
    # end

    # def add_years_rate_scores_race(name, subject_race, race, year, rate, state_test)
    #   asian = state_test.state_test_data[:asian]
    #   black = state_test.state_test_data[:black]
    #   pacific_islander = state_test.state_test_data[pacific_islander] #data file lists pacific_islander as hawaiian/pacific_islander
    #   hispanic = state_test.state_test_data[:hispanic]
    #   native_american = state_test.state_test_data[:native_american]
    #   two_or_more = state_test.state_test_data[:two_or_more]
    #   white = state_test.state_test_data[:white]
    #   if race == asian && race == "Math" && race["Math"].nil?
    #     race["Math"] = {year => rate}
    #   elsif race == :third_race && race == "Math" && race["Math"].count != 0
    #     race["Math"].merge!({year => rate})
    #   elsif race == :third_race && race == "Reading" && race["Reading"].nil?
    #     race["Reading"] = {year => rate}
    #   elsif race == :third_race && race == "Reading" && race["Reading"].count != 0
    #     race["Reading"].merge!({year => rate})
    #   elsif race == :third_race && race == "Writing" && race["Writing"].nil?
    #     race["Writing"] = {year => rate}
    #   elsif race == :third_race && race == "Writing" && race["Writing"].count != 0
    #     race["Writing"].merge!({year => rate})
    #   elsif race == :eighth_race && race == "Math" && race_8["Math"].nil?
    #     race["Math"] = {year => rate}
    #   elsif race == :eighth_race && race == "Math" && race["Math"].count != 0
    #     race["Math"].merge!({year => rate})
    #   elsif race == :eighth_race && race == "Reading" && race["Reading"].nil?
    #     race["Reading"] = {year => rate}
    #   elsif race == :eighth_race && race == "Reading" && race["Reading"].count != 0
    #     race["Reading"].merge!({year => rate})
    #   elsif race == :eighth_race && race == "Writing" &&  race["Writing"].nil?
    #     race["Writing"] = {year => rate}
    #   elsif race == :eighth_race && race == "Writing" &&  race["Writing"].count != 0
    #     race["Writing"].merge!({year => rate})
    #   end
    # end
end