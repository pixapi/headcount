class District
  attr_reader :district_info

  def initialize(district_info)
    @district_info = district_info
  end

  def name
    @district_info[:name].upcase
  end
end
