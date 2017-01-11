
require './lib/message_error'
class StatewideTest
  attr_reader :state_test_data,
              :name
  # GRADES = [3, 8]
  # RACES = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  # SUBJECT = [:math, :writing, :reading]
  #
  def initialize(state_test_data)
    @state_test_data = state_test_data
    @name = state_test_data[:name].upcase
  end

  # def convert_integer_to_symbol(grade)
  #   if grade == 3
  #     grade = :third_grade
  #   elsif grade == 8
  #     grade = :eighth_grade
  #   end
  # end

  def proficient_by_grade(grade)
    grade = :third_grade if grade == 3
    grade = :eighth_grade if grade == 8
    raise UnknownDataError unless state_test_data[grade]
    state_test_data[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless state_test_data[race]
    state_test_data[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    grade = :third_grade if grade == 3
    grade = :eighth_grade if grade == 8
    raise UnknownDataError unless state_test_data[grade][year][subject]
    state_test_data[grade][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless state_test_data[race][year][subject]
    state_test_data[race][year][subject]
  end
end
