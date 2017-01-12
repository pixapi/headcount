require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'
require 'pry'

class DistrictRepository
  attr_reader :enroll_repo,
              :districts,
              :statewide_repo,
              :economic_profile
  def initialize
    @districts = {}
    @enroll_repo =    EnrollmentRepository.new
    @statewide_repo = StatewideTestRepository.new
    @economic_profile = EconomicProfileRepository.new
  end

  def load_data(data_set)
    load_enrollment(data_set)
    load_statewide_testing(data_set)
    load_economic_profile(data_set)
    open_file(data_set)
  end

  def load_enrollment(data_set)
    if data_set.keys.include?(:enrollment)
      enrollment_data = {}
      enrollment_data[data_set.first[0]] = data_set.first[1]
      enroll_repo.load_data(enrollment_data)
    end
  end

  def load_statewide_testing(data_set)
    if data_set.keys.include?(:statewide_testing)
      statewide_testing_data = {}
      statewide_testing_data[:statewide_testing] = data_set[:statewide_testing]
      statewide_repo.load_data(statewide_testing_data)
    end
  end

  def load_economic_profile(data_set)
    if data_set.keys.include?(:economic_profile)
      economic_profile_data = {}
      economic_profile_data[:economic_profile] = data_set[:economic_profile]
      economic_profile.load_data(economic_profile_data)
    end
  end

  def open_file(data_set)
    file = CSV.open data_set[:enrollment][:kindergarten],
            headers: true, header_converters: :symbol
    create_district_object(data_set, file)
  end

  def create_district_object(data_set, file)
    file.each do |row|
      name = row[:location].upcase
      districts[name] = District.new({:name => name}, self)
    end
    enroll_repo.load_data(data_set)
  end

  def find_by_name(district_name)
    districts[district_name.upcase]
  end

  def find_all_matching(name_fragment)
    districts.find_all do |district|
      district[0].start_with?(name_fragment.upcase)
    end.map do |district|
      district[0]
    end
  end

  def find_enrollment(name)
    enroll_repo.find_by_name(name)
  end

  def find_statewide_test(name)
    statewide_repo.state_tests[name]
    # binding.pry
  end

  def find_profile(name)
    economic_profile.find_by_name(name)
  end
end
