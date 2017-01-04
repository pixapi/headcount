require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def test_it_has_a_class
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end
end
