require 'csv'
require './lib/enrollment'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  # def open_file(data_set) #maybe move this to module LoadData
  #   CSV.open data_set[:enrollment][:kindergarten], headers: true, header_converters: :symbol
  #   binding.pry
  # end

  def load_data(data_set)
    file = data_set[:enrollment][:kindergarten]
    contents = CSV.open file, headers: true, header_converters: :symbol
    # binding.pry
    contents.each do |row|
      name = row[:location].upcase
      year = row[:timeframe]
      rate = row[:data]
      # binding.pry
      if @enrollments.empty?
        # binding.pry
        @enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}})
      elsif @enrollments.keys.count(name) == 0
        # binding.pry
        @enrollments[name] = Enrollment.new({:name => name, :kindergarten_participation => {year =>rate}})
      elsif @enrollments.keys.include?(name) == true
        @enrollments[name].enrollment_data[:kindergarten_participation].merge!({year => rate})
      end
    end
    @enrollments
    # binding.pry
  end

  def find_by_name(district_name)
    @enrollments[district_name.upcase]
  end
end

er = EnrollmentRepository.new
er.load_data({
  :enrollment => {
    :kindergarten => "./test/fixtures/small_kindergartners_in_full_day.csv"
  }
})
p er.find_by_name("Colorado")
