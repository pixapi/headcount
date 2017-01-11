class EconomicProfile
  def initialize(profile_data)
    @profile_data = profile_data
    @name = profile_data[:name].upcase
  end
end
