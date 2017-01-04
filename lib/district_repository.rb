require 'csv'
require './lib/district'
require 'pry'

class DistrictRepository
  def load_data(data_set)
    @file = CSV.open data_set[:enrollment][:kindergarten], headers: true, header_converters: :symbol
  end

  def find_by_name(district_name)
    @file.find do |row|
      @matching_district = district_name.upcase
      location = row[:location] #if used often put in initialize
      if location.include?(@matching_district) #another option ==
        @matching_district = District.new
      else
        @matching_district = nil
      end
    end
    @matching_district
  end

  def find_all_matching(name_fragment)
    @file.find_all do |row|
      location = row[:location]
      location.include?(name_fragment)
    end
  end
end

# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }})
#   dr.find_by_name("ACADEMY 20")
#   dr.find_by_name("ARIZONA")
