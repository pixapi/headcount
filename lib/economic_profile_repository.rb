require 'csv'
require_relative 'economic_profile'
require 'pry'

class EconomicProfileRepository
  attr_reader :profiles,
              :file_keys

  def initialize
    @profiles = {}
    @file_keys = {
      :median_household_income => :median_household_income,
      :children_in_poverty => :children_in_poverty,
      :free_or_reduced_price_lunch => :free_or_reduced_price_lunch,
      :title_i => :title_i
      }
  end

  def find_by_name(name)
    @profiles[name.upcase]
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
      check_loadpath(data, filepath, index)
    end
  end

  def check_loadpath(data, filepath, index)
     if filepath.include?("income")
       parse_income(data, filepath, index)
       binding.pry
     elsif filepath.include?("poverty")
       parse_poverty(data, filepath, index)
     elsif filepath.include?("lunch")
       parse_lunch(data, filepath, index)
     elsif filepath.include?("Title")
       parse_title(data, filepath, index)
     end
   end

  def parse_income(data, filepath, index)
      CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
        name = row[:location].upcase
        year = row[:timeframe].split("-").map { |num| num.to_i }
        income = "N/A"
        income = row[:data].to_i if row[:data] != "N/A"
        file_key = file_keys.values[index]
        profile = find_by_name(name)
        create_income(name, year, income, profile, file_key)
      end
  end

  def create_income(name, year, income, profile, file_key)
    attributes = {:name => name, file_key => {year => income}}
    if profile.nil?
      profiles[name] = EconomicProfile.new(attributes)
    elsif profile.profile_data[file_key][year].nil?
      profile.profile_data[file_key][year] = income
    end
  end

end

##########################################################################
##########################################################################
  # def rejected_lines(row)
  #   row[:poverty_level].to_s.downcase.include?("or") == false
  # end

  # def set_percent_number(row)
  #   if row[:dataformat].to_s.downcase == "percent"
  #     "percent"
  #   elsif row[:dataformat].to_s.downcase == "number"
  #     "number"
  #   end
  # end

  # def extract_lunch_file(data, symbol, filepath)
  #   CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
  #       row[:poverty_level].downcase != "elegible for free or reduced lunch"
  #       name = row[:location].upcase
  #       year = row[:timeframe].to_i
  #       binding.pry
  #       if set_percent_number(row) == "percent"
  #         percent = "percent"
  #       else
  #         number = "number"
  #       end
  #       percent = set_percent_number(row)
  #       profile = find_by_name(name)
  #     end
  #     # rate = 0 if rate == "NA" || rate == "N/A" || rate == "LNE"
  #     # grade = grade_levels[data.values[0].keys[index]]
  #       create_lunch_profile(name, year, percent, total, profile)
  #   end
  # end

  # def extract_rest_file(data, filepath, index)
  #   CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
  #     # next if row[:poverty_level].to_s.downcase.include?("or") == false
  #     name = row[:location].upcase
  #     year = row[:timeframe].to_i #year_range or year
  #     data_type = row[:dataformat] #currency or percent/number
  #     data = row[:data] #income, rate or number
  #     # if row[:dataformat].to_s.downcase == "percent"
  #     #   percent = row[:data].to_f
  #     # elsif row[:dataformat].to_s.downcase == "number"
  #     #   total = row[:data]
  #     end
  #     # rate = 0 if rate == "NA" || rate == "N/A" || rate == "LNE"
  #     # grade = grade_levels[data.values[0].keys[index]]
  #     profile = find_by_name(name)
  #     create_lunch_profile(name, year, percent, total, profile)
  # end
  #
  # # def create_lunch_profile(name, year, percent, total, profile)
  # #   attributes = {:name => name, :free_or_reduced_price_lunch =>{year => {:percentage => percent, :total => total}}}
  # #   if profile.nil?
  # #     profiles[name] = EconomicProfile.new(attributes)
  # #   elsif profile.profile_data[:free_or_reduced_price_lunch][year].nil?
  # #     profile.profile_data[:free_or_reduced_price_lunch][year] = {:percentage => rate, :total => total}
  # #   end
  # # end
  #
  # # def create_rest_profile(name, year, percent, total, profile)
  # #   attributes = {:name => name, :free_or_reduced_price_lunch =>{year => {:percentage => percent, :total => total}}}
  # #   if profile.nil?
  # #     profiles[name] = EconomicProfile.new(attributes)
  # #   elsif profile.profile_data[:free_or_reduced_price_lunch][year].nil?
  #     profile.profile_data[:free_or_reduced_price_lunch][year] = {:percentage => rate, :total => total}
  #   end
  # end