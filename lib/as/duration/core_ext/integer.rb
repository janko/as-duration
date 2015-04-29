class Integer
  def months
    AS::Duration.new(self * 30*24*60*60, [[:months, self]])
  end
  alias month months

  def years
    AS::Duration.new(self * 365*24*60*60, [[:years, self]])
  end
  alias year years
end
