class StatewideTest
  attr_reader :state_test_data,
              :name

  def initialize(state_test_data)
    @state_test_data = state_test_data
    @name = state_test_data[:name].upcase
  end
end
