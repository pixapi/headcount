require 'csv'
require './lib/enrollment'
require 'pry'

class EnrollmentRepository
  def load_data(data_set) #maybe move this to module LoadData
    @file = CSV.open data_set[:enrollment][:kindergarten],
    headers: true, header_converters: :symbol
  end

  def find_by_name(district_name)
    found_district = @file.find_all do |row|
      district_name = district_name.upcase
      row[:location].upcase == district_name
    end
    determine_district_validity(found_district, district_name)
  end

  def determine_district_validity(found_district, district_name)
    if found_district == []
      nil
    elsif found_district[0][:location] == district_name
      build_enrollment_data(found_district)
    end
  end

  def build_enrollment_data(found_district)
    years = []
    rates = []
    found_district.each do |row|
      years << row[:timeframe].to_i
      rates << row[:data].to_f
    end
    year_rate = years.zip(rates).to_h
    create_enrollment_instance(found_district, year_rate)
  end

  def create_enrollment_instance(found_district, year_rate)
    enrollment = {}
    enrollment[:name] = found_district[0][:location]
    enrollment[:kindergarten_participation] = year_rate
    Enrollment.new(enrollment)
  end
end

# er = EnrollmentRepository.new
# er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# p er.find_by_name("Colorado")
