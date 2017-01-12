
require_relative 'message_error'

class StatewideTest
  attr_reader :state_test_data,
              :name

  def initialize(state_test_data)
    @state_test_data = state_test_data
    @name = state_test_data[:name].upcase
  end

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
    raise UnknownDataError unless find_my_error_and_raise(subject, race, year)
    state_test_data[race][year][subject]
  end

  def find_my_error_and_raise(subject, race, year)
    state_test_data[race] && state_test_data[race][year] && state_test_data[race][year][subject]
  end
end
