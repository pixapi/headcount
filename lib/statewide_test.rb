class StatewideTest
  attr_reader :state_test_data,
              :name

  def initialize(state_test_data)
    @state_test_data = state_test_data
    @name = state_test_data[:name].upcase
  end

  def convert_integer_to_symbol(grade)
    if grade == 3
      grade = :third_grade
    elsif grade == 8
      grade = :eighth_grade
    end
  end

  def raise_grades_error(grade)
    raise ArgumentError, "UnknownDataError" if grade != 3 || grade != 8
  end

  def proficient_by_grade(grade)
    if grade == 3
      grade = :third_grade
    elsif grade == 8
      grade = :eighth_grade
    end
    # raise_grades_error(grade)
    state_test_data[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    # if state_test_data[race].nil?
    #   "UnknownRaceError"
    # else
      state_test_data[race]
    # ed
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    grade = :third_grade if grade == 3
    grade = :eighth_grade if grade == 8
    #IF GRACE, SUBJECT OR YEAR NOT FOUND SAME ERROR
    state_test_data[grade][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    state_test_data[race][year][subject]
  end
end
