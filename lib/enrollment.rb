class Enrollment
  def initialize(enrollment_data)
    @enrollment_data = enrollment_data
  end

  def kindergarten_participation_by_year
    enrollment_data_hash = @enrollment_data[:kindergarten_participation]
    enrollment_data_hash.inject({}) { |h, (k, v)| h[k] = (v * 1000).floor / 1000.0; h}
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

end

# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
# puts e.kindergarten_participation_by_year