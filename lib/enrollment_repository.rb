require 'csv'
require_relative 'enrollment'
require 'pry'

###################### MAYBE CHANGE enrollment for er in all files?#########
class EnrollmentRepository

  attr_reader :enrollments,
              :grade_levels

  def initialize
    @enrollments = {}
    @grade_levels = {:kindergarten => :kindergarten_participation,
                     :high_school_graduation => :high_school_graduation}
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
      open_file(data, filepath, index)
    end
  end

  def open_file(data, filepath, index)
    CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      year = row[:timeframe].to_i
      rate = row[:data].to_f
        rate = 0 if rate == "NA" || rate == "N/A"
      grade = grade_levels[data.values[0].keys[index]]
      enrollment = find_by_name(name)
      create_enrollment(name, year, rate, grade, enrollment)
    end
  end

  def create_enrollment(name, year, rate, grade, enrollment)
    attributes = {:name => name, grade => {year => rate}}
    if enrollment.nil?
      enrollments[name] = Enrollment.new(attributes)
    elsif enrollment.enrollment_data[grade].nil?
      enrollment.enrollment_data[grade] = {year => rate}
    else
      add_enrollment_data(grade, year, rate, enrollment)
    end
  end

  def add_enrollment_data(grade, year, rate, er)
    if grade == :kindergarten_participation
      er.enrollment_data[:kindergarten_participation].merge!({year => rate})
    else
      er.enrollment_data[:high_school_graduation].merge!({year => rate})
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end

end
