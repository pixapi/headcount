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
    trend = Hash[trend.sort_by {|key,val| key}]
    # binding.pry
  end

  def get_years_rate(place)
    @district_repo.find_enrollment(place).kindergarten_participation_by_year
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder_var = kindergarten_participation_rate_variation(district, :against => "COLORADO")
    grad_var = variation_from_district_graduation_against_state_graduation(district)
    result = kinder_var/grad_var
     (result * 1000).floor / 1000.0
  end

  def variation_from_district_graduation_against_state_graduation(district)
    state = "COLORADO"
    average_district = calculate_graduation_average(district)
    average_state = calculate_graduation_average(state)
    result = average_district/average_state
    (result * 1000).floor / 1000.0
  end

  def calculate_graduation_average(place)
    array = @district_repo.find_enrollment(place).graduation_rate_by_year.values
    result = array.reduce(:+)/array.count
    (result * 1000).floor / 1000.0
  end
end
