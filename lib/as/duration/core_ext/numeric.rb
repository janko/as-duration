class Numeric
  def seconds
    AS::Duration.new(self, [[:seconds, self]])
  end
  alias second seconds

  def minutes
    AS::Duration.new(self * 60, [[:minutes, self]])
  end
  alias minute minutes

  def hours
    AS::Duration.new(self * 60*60, [[:hours, self]])
  end
  alias hour hours

  def days
    AS::Duration.new(self * 24*60*60, [[:days, self]])
  end
  alias day days

  def weeks
    AS::Duration.new(self * 7*24*60*60, [[:weeks, self]])
  end
  alias week weeks

  def fortnights
    AS::Duration.new(self * 14*24*60*60, [[:weeks, self * 2]])
  end
  alias fortnight fortnights
end
