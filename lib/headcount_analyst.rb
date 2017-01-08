class HeadcountAnalyst
  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(place_one, place_two)
    average_one = calculate_average(place_one)
    average_two = calculate_average(place_two[:against])
    result = average_one/average_two
    (result * 1000).floor / 1000.0
  end

  def calculate_average(place)
    array = @district_repo.find_enrollment(place).kindergarten_participation_by_year.values
    array.reduce(:+)/array.count
  end

  def kindergarten_participation_rate_variation_trend(place_one, place_two)
    hash_one = get_years_rate(place_one)
    hash_two = get_years_rate(place_two[:against])
    trend = hash_one.inject({}) do |h, (k, v)|
      h[k] = ((hash_one[k]/hash_two[k])* 1000).floor / 1000.0; h
    end
    # trend = Hash[trend.sort_by {|key,val| key}]
    # binding.pry
  end

  def get_years_rate(place)
    @district_repo.find_enrollment(place).kindergarten_participation_by_year
  end

    #we want to have two hashes to compare
    #we want to create a new hash where values are district/stat

end
