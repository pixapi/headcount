class EconomicProfile
    attr_reader :profile_data
    
  def initialize(profile_data)
    @profile_data = profile_data
    @name = profile_data[:name].upcase
  end
end
