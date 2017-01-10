require_relative 'clean_math'

class HeadcountAnalyst
  include CleanMath
  attr_reader :dr
  def initialize(dr)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(place_one, place_two)
    average_one = calculate_average(place_one)
    average_two = calculate_average(place_two[:against])
    average_two = 1 if average_two == 0
    result = average_one/average_two
    (result * 1000).floor / 1000.0
  end

  def calculate_average(place)
    array = dr.find_enrollment(place).kindergarten_participation_by_year.values
    array.count = 1 if array.count == 0
    array.reduce(:+)/array.count
  end

  def kindergarten_participation_rate_variation_trend(place_one, place_two)
    hash_one = get_years_rate(place_one)
    hash_two = get_years_rate(place_two[:against])
    trend = hash_one.inject({}) do |h, (k, v)|
      h[k] = ((hash_one[k]/hash_two[k])* 1000).floor / 1000.0; h
    end
    trend = Hash[trend.sort_by {|key,val| key}]
  end

  def get_years_rate(place)
    dr.find_enrollment(place).kindergarten_participation_by_year
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder_var = kindergarten_participation_rate_variation(district, :against => "COLORADO")
    grad_var = variation_from_district_graduation_against_state_graduation(district)
    grad_var = 1 if grad_var == 0
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
    array = dr.find_enrollment(place).graduation_rate_by_year.values
    result = array.reduce(:+)/array.count
    (result * 1000).floor / 1000.0
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    if district[:for] == 'STATEWIDE'
      variation_statewide
    else
      district = district[:for]
      result = variation_from_district_graduation_against_state_graduation(district)
      result >= 0.6 && result <= 1.5
    end
  end

  def variation_statewide
    variations = []
    dr.enroll_repo.enrollments.each do |district, enrollment|
      variations << kindergarten_participation_against_high_school_graduation(district)
    end
    state_var = variations.count do |variation|
      variation >= 0.6 && variation <= 1.5
    end
    state_var.to_f / variations.count >= 0.7
  end
end
