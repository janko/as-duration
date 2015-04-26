class Numeric
  def seconds
    AS::Duration.new(seconds: self)
  end
  alias second seconds

  def minutes
    AS::Duration.new(minutes: self)
  end
  alias minute minutes

  def hours
    AS::Duration.new(hours: self)
  end
  alias hour hours

  def days
    AS::Duration.new(days: self)
  end
  alias day days

  def weeks
    AS::Duration.new(weeks: self)
  end
  alias week weeks

  def fortnights
    AS::Duration.new(weeks: self * 2)
  end
  alias fortnight fortnights
end
