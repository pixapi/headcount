require 'csv'
require_relative 'enrollment'
require 'pry'

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
      rate = ((row[:data].to_f) * 1000).floor / 1000.0
      grade = grade_levels[data.values[0].keys[index]]
      enrollment = find_by_name(name)
      if enrollment == nil
        enrollments[name] = Enrollment.new({:name => name, grade => {year => rate}})
      elsif grade == :high_school_graduation
        enrollment = enrollments[name]
        enrollment.enrollment_data[:high_school_graduation] = {year => rate}
      else
        add_years_rate(enrollment, grade, year, rate)
      end
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

  # def load_data(data_set)
  #   contents = open_file(data_set[:enrollment][:kindergarten])
  #   contents.each do |row|
  #     name = row[:location].upcase
  #     year = row[:timeframe].to_i
  #     rate = row[:data].to_f
  #     add_to_enrollments(name, year, rate)
  #   end
  # end

  # def add_to_enrollments(name, year, rate)
  #     if @enrollments.empty?
  #       @enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}})
  #     elsif @enrollments.keys.count(name) == 0
  #       @enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}})
  #     elsif @enrollments.keys.include?(name) == true
  #       @enrollments[name].enrollment_data[:kindergarten_participation].merge!({year => rate})
  #     end
  #   @enrollments[name]
  # end
