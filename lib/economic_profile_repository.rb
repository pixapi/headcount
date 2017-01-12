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
     elsif filepath.include?("poverty")
       parse_poverty(data, filepath, index)
      #  binding.pry
     elsif filepath.include?("lunch")
       parse_lunch(data, filepath, index)
       binding.pry
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

def parse_poverty(data, filepath, index)
  CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
    name = row[:location].upcase
    year = row[:timeframe].split("-").map { |num| num.to_i }
    data_type = row[:dataformat].to_s.downcase
    rate_total = row[:data]
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
    p_level = row[:poverty_level].to_s.downcase
    year = row[:timeframe].to_i
    data_type = row[:dataformat].to_s.downcase
    rate_total = row[:data].to_i
    file_key = file_keys.values[index]
    profile = find_by_name(name)
    create_lunch(name, p_level, year, data_type, rate_total, file_key, profile)
  end
end

def create_lunch(name, p_level, year, data_type, rate_total, file_key, profile)
  percent = rate_total if data_type == "percent"
  total = rate_total if data_type == "number"
  attributes = {:name => name, file_key => {year => {:percentage => percent, :total => total}}}
  if profile.profile_data[file_key].nil?
    profile.profile_data[file_key] = {year => {:percentage => percent, :total => total}}
  elsif profile.profile_data[file_key][year].nil?
    profile.profile_data[file_key][year] = {:percentage => percent, :total => total}
  end
end

##############
def parse_title(data, filepath, index)
  CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
    name = row[:location].upcase
    year = row[:timeframe]
    data_type = row[:dataformat].to_s.downcase
    rate_total = row[:data]
    file_key = file_keys.values[index]
    profile = find_by_name(name)
    create_lunch(name, p_level, year, data_type, rate_total, file_key, profile)
  end
end

def create_title(name, p_level, year, data_type, rate_total, file_key, profile)
  good_row = p_level == "elegible for free or reduced lunch"
  # binding.pry
  percent = rate_total if data_type == "percent"
  total = rate_total if data_type == "number"
  attributes = {:name => name, file_key => {year => {:percentage => percent, :total => total}}}
  if good_row && profile.nil?
    # binding.pry
    profiles[name] = EconomicProfile.new(attributes)
  elsif good_row && profile.profile_data[file_key].nil?
    profile.profile_data[file_key] = {year => {:percentage => percent, :total => total}}
  elsif good_row && profile.profile_data[file_key][year].nil?
    good_row && profile.profile_data[file_key][year] = {:percentage => percent, :total => total}
  end
end
