require_relative 'message_error'

class EconomicProfile
    attr_reader :profile_data,
                :name

  def initialize(profile_data)
    @profile_data = profile_data
    @name = profile_data[:name]
  end

  def median_household_income_in_year(year)
    years = []
    profile_data[:median_household_income].keys.map do |key|
      if year.between?(key[0], key[1])
        years << profile_data[:median_household_income][key]
      end
    end
    years.reduce(:+)/years.count
  end

  def median_household_income_average
    income = profile_data[:median_household_income].values.reduce(:+)
    income/profile_data[:median_household_income].values.count
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError unless profile_data[:children_in_poverty][year]
    ((profile_data[:children_in_poverty][year]) * 1000).floor/1000.0
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    l_per = profile_data[:free_or_reduced_price_lunch][year]
    raise UnknownDataError unless l_per
    l_per[:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    l_num = profile_data[:free_or_reduced_price_lunch][year][:total]
    raise UnknownDataError unless l_num
    l_num
  end

  def title_i_in_year(year)
    raise UnknownDataError unless profile_data[:title_i][year]
    profile_data[:title_i][year]
  end
end
