class StatewideTest
  attr_reader :state_test_data,
              :name

  def initialize(state_test_data)
    @state_test_data = state_test_data
    @name = state_test_data[:name].upcase
  end

  def proficient_by_grade(grade)
    if grade == 3
      grade = :third_grade
    elsif grade == 8
      grade = :eighth_grade
    else
      return "UnknownDataError"
    end
    state_test_data[grade]
  end
end
