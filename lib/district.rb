class District
  def initialize(name)
    @name = name
  end

  def name
    @name[:name].upcase
  end
end
