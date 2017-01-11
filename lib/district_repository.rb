require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require 'pry'

class DistrictRepository
  attr_reader :enroll_repo,
              :districts,
              :statewide_repo
  def initialize
    @districts = {}
    @enroll_repo =    EnrollmentRepository.new
    @statewide_repo = StatewideTestRepository.new
  end

  def load_data(data_set)
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
    statewide_repo.find_by_name(name)
  end
end
