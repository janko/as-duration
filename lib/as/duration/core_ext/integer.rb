class Integer
  def months
    AS::Duration.new(months: self)
  end
  alias month months

  def years
    AS::Duration.new(years: self)
  end
  alias year years
end
