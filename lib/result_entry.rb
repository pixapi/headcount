class ResultEntry
  attr_reader :result_data

  def initialize(result_data)
    @result_data = result_data
  end

  def free_and_reduced_price_lunch_rate
    result_data[:free_and_reduced_price_lunch_rate]
  end

  def children_in_poverty_rate
    result_data[:children_in_poverty_rate]
  end

  def high_school_graduation_rate
    result_data[:high_school_graduation_rate]
  end

  def median_household_income
    result_data[:median_household_income]
  end

end