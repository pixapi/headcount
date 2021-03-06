class Enrollment
  attr_reader :enrollment_data,
              :name
              
  def initialize(enrollment_data)
    @enrollment_data = enrollment_data
    @name = enrollment_data[:name].upcase
  end

  def kindergarten_participation_by_year
    enrollment_data_hash = enrollment_data[:kindergarten_participation]
    enrollment_data_hash.inject({}) do |h, (k, v)|
      h[k] = (v * 1000).floor / 1000.0; h
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def graduation_rate_by_year
    graduation_rate_hash = enrollment_data[:high_school_graduation]
    graduation_rate_hash.inject({}) do |h, (k, v)|
      h[k] = (v * 1000).floor / 1000.0; h
    end
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end
end
