class Enrollment
  def initialize(enrollment_data)
    @enrollment_data = enrollment_data
  end

  def kindergarten_participation_by_year
    enrollment_data_hash = @enrollment_data[:kindergarten_participation]
    enrollment_data_hash.inject({}) do |h, (k, v)|
      h[k] = (v * 1000).floor / 1000.0; h
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

end
