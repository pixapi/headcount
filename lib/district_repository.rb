require 'csv'
require_relative 'district'
require 'pry'

class DistrictRepository

  def initialize
    @districts = {}
  end


  def load_data(data_set)
    @file = CSV.open data_set[:enrollment][:kindergarten],
            headers: true, header_converters: :symbol

    @file.each do |row|
      name = row[:location]
      @districts[name] = District.new({:name => name})
    end
  end

  def find_by_name(district_name)
    @districts[district_name.upcase]
  end

  def find_all_matching(name_fragment)
    @districts.find_all do |district|
      district[0].start_with?(name_fragment.upcase)
    end.map do |district|
      district[0]
    end
  end
end

# dr = DistrictRepository.new
# dr.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }})
#   puts dr.find_by_name("ACADEMY 20")
#   dr.find_by_name("ARIZONA")
