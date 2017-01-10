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
      distribution(name, year, rate, grade, enrollment)
    end
  end

  def distribution(name, year, rate, grade, enrollment)
    if enrollment == nil
      enrollments[name] = Enrollment.new({:name => name, grade => {year => rate}})
    elsif grade == :high_school_graduation && enrollment.enrollment_data[:high_school_graduation].nil?
      enrollment = enrollments[name]
      enrollment.enrollment_data[:high_school_graduation] = {year => rate}
    elsif grade == :high_school_graduation && enrollment.enrollment_data[:high_school_graduation].count != 0
      add_years_rate(enrollment, grade, year, rate)
    else
      add_years_rate(enrollment, grade, year, rate)
    end
  end

  def add_years_rate(enrollment, grade, year, rate)
    if grade == :kindergarten_participation
      enrollment.enrollment_data[:kindergarten_participation].merge!({year => rate})
    elsif grade == :high_school_graduation
      enrollment.enrollment_data[:high_school_graduation].merge!({year => rate})
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end

end
