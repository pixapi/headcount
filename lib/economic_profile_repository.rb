require 'csv'
require_relative 'economic_profile'
require 'pry'

class EconomicProfileRepository
  attr_reader :profiles
  def initialize
    @profiles = {}
  end

  def load_data(data)
    data[:economic_profile].each do |symbol, filepath|
    # data.values[0].values.each_with_index do |filepath, index|
      if filepath.include?("lunch")
        extract_lunch_file(data, symbol, filepath) #index?
      else
        "hello"
      #   extract_rest_file(data, filepath, index)
      end
    end
  end

  # def rejected_lines(row)
  #   row[:poverty_level].to_s.downcase.include?("or") == false
  # end

  def set_percent_number(row)
    if row[:dataformat].to_s.downcase == "percent"
      "percent"
    elsif row[:dataformat].to_s.downcase == "number"
      "number"
    end
  end

  def extract_lunch_file(data, symbol, filepath)
    CSV.foreach(filepath,headers: true, header_converters: :symbol) do |row|
        row[:poverty_level].downcase != "elegible for free or reduced lunch"
        name = row[:location].upcase
        year = row[:timeframe].to_i
        binding.pry
        if set_percent_number(row) == "percent"
          percent = "percent"
        else
          number = "number"
        end
        percent = set_percent_number(row)
        profile = find_by_name(name)
      end
      # rate = 0 if rate == "NA" || rate == "N/A" || rate == "LNE"
      # grade = grade_levels[data.values[0].keys[index]]
        create_lunch_profile(name, year, percent, total, profile)
    end
  end

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

  def find_by_name(name)
    @profiles[name.upcase]
  end
end
