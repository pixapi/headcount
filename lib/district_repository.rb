require 'csv'
require_relative 'district'
require 'pry'

class DistrictRepository
  def load_data(data_set)
    @file = CSV.open data_set[:enrollment][:kindergarten],
            headers: true, header_converters: :symbol
  end

  def find_by_name(district_name)
    @file.find do |row|
      @matching_district = district_name.upcase
      if row[:location].include?(@matching_district) #another option ==
        @matching_district = District.new(@matching_district)
      else
        @matching_district = nil
      end
    end
    @matching_district
  end

  def find_all_matching(name_fragment)
    district_names = []
    @file.find_all do |row|
      row[:location].upcase.start_with?(name_fragment.upcase) #location.include?(name_fragment.upcase)
    end.each do |element|
      district_names << element[:location]
    end
    district_names.uniq
  end
end

# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }})
#   puts dr.find_by_name("ACADEMY 20")
#   dr.find_by_name("ARIZONA")
