require 'csv'
require_relative 'enrollment'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def open_file(filename)
    CSV.open filename, headers: true, header_converters: :symbol
  end

  def load_data(data_set)
    kinder_data = open_file(data_set[:enrollment][:kindergarten])
    high_data = open_file(data_set[:enrollment][:high_school_graduation])
    level_k = "kinder" 
    level_h = "high"
    parse_data(kinder_data, level_k)
    parse_data(high_data, level_h)
  end

  def parse_data(data, level = "kinder")
    data.each do |row|
      name = row[:location].upcase
      year = row[:timeframe].to_i
      rate = row[:data].to_f
      add_to_enrollments(name, year, rate, level)
    end
  end

  def add_to_enrollments(name, year, rate, level = "kinder")
    if enrollments.empty?
      enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}, :high_school_graduation => {}})
      #^^^^ use abbreviations for key symbols (over 80 lines)
    elsif level == "kinder"
      if enrollments.keys.count(name) == 0
       enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}, :high_school_graduation => {}})
      elsif enrollments.keys.include?(name) == true
        enrollments[name].enrollment_data[:kindergarten_participation].merge!({year => rate})
      end
    elsif level == "high"
      if enrollments.keys.count(name) == 0
       enrollments[name].high_school_graduation[year] = rate
      elsif enrollments.keys.include?(name) == true
      enrollments[name].enrollment_data[:high_school_graduation].merge!({year => rate})
      end
  end
    enrollments[name]
  end

  def find_by_name(name)
    enrollments[name.upcase]
  end

end
