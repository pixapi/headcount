require 'csv'
require './lib/enrollment'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def open_file(data_set) #maybe move this to module LoadData
    see = CSV.open data_set[:enrollment][:kindergarten], headers: true, header_converters: :symbol
    binding.pry
  end

  def load_data(data_set)
    contents = open_file(data_set)

    contents.each do |row|
      name = row[:location]
      year = row[:timeframe]
      rate = row[:data]
      @enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}})
      binding.pry
    end
    p @enrollments
  end

  def find_by_name(district_name)
    binding.pry
    @enrollments[district_name.upcase]
    binding.pry
  end
end

er = EnrollmentRepository.new
er.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"
  }
})
p er.find_by_name("Colorado")
