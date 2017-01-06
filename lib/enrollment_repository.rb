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
    contents = open_file(data_set[:enrollment][:kindergarten])
    contents.each do |row|
      name = row[:location].upcase
      year = row[:timeframe]
      rate = row[:data]
      add_to_enrollments(name, year, rate)
    end
  end

  def add_to_enrollments(name, year, rate)
      if @enrollments.empty?
        @enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}})
      elsif @enrollments.keys.count(name) == 0
        @enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}})
      elsif @enrollments.keys.include?(name) == true
        @enrollments[name].enrollment_data[:kindergarten_participation].merge!({year => rate})
      end
    @enrollments[name]
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end
end
