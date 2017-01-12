require_relative 'result_entry'

class ResultSet
  attr_reader :matching_districts,
              :statewide_average

  def initialize(matching_districts:, statewide_average:)
    @matching_districts = matching_districts
    @statewide_average = statewide_average
  end
end