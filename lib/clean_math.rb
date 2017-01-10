module CleanMath
  def short_clean(data)
    data = 0 if data.nan?
    # (data * 1000).floor / 1000.0
  end
end
