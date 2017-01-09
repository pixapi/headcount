require_relative 'district_repository'
class District
  attr_reader :district_info

  def initialize(district_info, district_repository = nil)
    @district_info = district_info
    @district_repository = district_repository
  end

  def name
    @district_info[:name].upcase
  end

  def enrollment
    district_name = name
    @district_repository.find_enrollment(district_name)
    #return instance of enrollment
  end
end
