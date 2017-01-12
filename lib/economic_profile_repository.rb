require 'csv'
require_relative 'economic_profile'

class EconomicProfileRepository
  attr_reader :profiles,
              :file_keys

  def initialize
    @profiles = {}
    @file_keys = {
      :median_household_income => :median_household_income,
      :children_in_poverty => :children_in_poverty,
      :free_or_reduced_price_lunch => :free_or_reduced_price_lunch,
      :title_i => :title_i}
  end

  def find_by_name(name)
    profiles[name.upcase]
  end

  def load_data(data)
    data.values[0].values.each_with_index do |filepath, index|
      check_loadpath(data, filepath, index)
    end
  end

  def check_loadpath(data, filepath, index)
    if filepath.include?("income")
      parse_income(data, filepath, index)
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

  def parse_poverty(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      year = row[:timeframe].to_i
      data_type = row[:dataformat].to_s.downcase
      rate_total = row[:data].to_f
      file_key = file_keys.values[index]
      profile = find_by_name(name)
      create_poverty(name, year, data_type, rate_total, file_key, profile)
    end
  end

  def create_poverty(name, year, data_type, rate_total, file_key, profile)
    percent = rate_total if data_type == "percent"
    attributes = {:name => name, file_key => {year => percent}}
    if data_type == "percent" && profile.profile_data[file_key].nil?
      profile.profile_data[file_key] = {year => percent}
    elsif data_type == "percent" && profile.profile_data[file_key][year].nil?
      profile.profile_data[file_key][year] = percent
    end
  end

  def parse_lunch(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      p_lev = row[:poverty_level].to_s.downcase
      year = row[:timeframe].to_i
      if row[:dataformat] == "Percent"
        data_type = :percentage
      else
        data_type = :total
      end
      if data_type == :percentage
        rate_total = row[:data].to_f if row[:data] != "N/A"
      else
        rate_total = row[:data].to_i if row[:data] != "N/A"
      end
      file_key = file_keys.values[index]
      profile = find_by_name(name)
      create_lunch(name, p_lev, year, data_type, rate_total, file_key, profile)
    end
  end

  def create_lunch(name, p_lev, year, data_type, rate_total, file_key, profile)
    if profile.profile_data[file_key].nil?
      profile.profile_data[file_key] = {year => {data_type => rate_total}}
    elsif profile.profile_data[file_key][year].nil?
      profile.profile_data[file_key][year] = {data_type => rate_total}
    elsif profile.profile_data[file_key][year][data_type].nil?
      profile.profile_data[file_key][year][data_type] = rate_total
    else
      profile.profile_data[file_key][year][data_type] = rate_total
    end
  end

  def parse_title(data, filepath, index)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      year = row[:timeframe].to_i
      rate = row[:data].to_f
      file_key = file_keys.values[index]
      profile = find_by_name(name)
      create_title(name, year, rate, file_key, profile)
    end
  end

  def create_title(name, year, rate, file_key, profile)
    if profile.profile_data[file_key].nil?
      profile.profile_data[file_key] = {year => rate}
    elsif profile.profile_data[file_key][year].nil?
      profile.profile_data[file_key][year] = rate
    end
  end
end
