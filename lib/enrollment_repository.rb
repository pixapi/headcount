require 'csv'
require './lib/enrollment'

class EnrollmentRepository
  def load_data(data_set)
    @file = CSV.open data_set[:enrollment][:kindergarten], headers: true, header_converters: :symbol
  end

  def find_by_name(district_name)
    @file.find do |row|
      @matching_district = district_name.upcase
      location = row[:location] #if used often put in initialize
      if location.include?(@matching_district) #another option ==
        @matching_district = Enrollment.new
      else
        @matching_district = nil
      end
    end
    @matching_district
  end

end