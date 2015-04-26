module DateAndTimeBehaviour
  def with_env_tz(new_tz = 'US/Eastern')
    old_tz, ENV['TZ'] = ENV['TZ'], new_tz
    yield
  ensure
    old_tz ? ENV['TZ'] = old_tz : ENV.delete('TZ')
  end

  def test_days_until
    assert_equal new(2005,6,4,10,10,10),   1.days.until(new(2005,6,5,10,10,10))
    assert_equal new(2005,5,31,10,10,10),  5.days.until(new(2005,6,5,10,10,10))
  end

  def test_days_from
    assert_equal new(2005,6,6,10,10,10),   1.days.from(new(2005,6,5,10,10,10))
    assert_equal new(2005,1,1,10,10,10),   1.days.from(new(2004,12,31,10,10,10))
  end

  def test_weeks_until
    assert_equal new(2005,5,29,10,10,10),  1.weeks.until(new(2005,6,5,10,10,10))
    assert_equal new(2005,5,1,10,10,10),   5.weeks.until(new(2005,6,5,10,10,10))
    assert_equal new(2005,4,24,10,10,10),  6.weeks.until(new(2005,6,5,10,10,10))
    assert_equal new(2005,2,27,10,10,10),  14.weeks.until(new(2005,6,5,10,10,10))
    assert_equal new(2004,12,25,10,10,10), 1.weeks.until(new(2005,1,1,10,10,10))
  end

  def test_weeks_from
    assert_equal new(2005,7,14,10,10,10), 1.weeks.from(new(2005,7,7,10,10,10))
    assert_equal new(2005,7,14,10,10,10), 1.weeks.from(new(2005,7,7,10,10,10))
    assert_equal new(2005,7,4,10,10,10),  1.weeks.from(new(2005,6,27,10,10,10))
    assert_equal new(2005,1,4,10,10,10),  1.weeks.from(new(2004,12,28,10,10,10))
  end

  def test_months_until
    assert_equal new(2005,5,5,10,10,10),  1.months.until(new(2005,6,5,10,10,10))
    assert_equal new(2004,11,5,10,10,10), 7.months.until(new(2005,6,5,10,10,10))
    assert_equal new(2004,12,5,10,10,10), 6.months.until(new(2005,6,5,10,10,10))
    assert_equal new(2004,6,5,10,10,10),  12.months.until(new(2005,6,5,10,10,10))
    assert_equal new(2003,6,5,10,10,10),  24.months.until(new(2005,6,5,10,10,10))
  end

  def test_months_from
    assert_equal new(2005,7,5,10,10,10),   1.months.from(new(2005,6,5,10,10,10))
    assert_equal new(2006,1,5,10,10,10),   1.months.from(new(2005,12,5,10,10,10))
    assert_equal new(2005,12,5,10,10,10),  6.months.from(new(2005,6,5,10,10,10))
    assert_equal new(2006,6,5,10,10,10),   6.months.from(new(2005,12,5,10,10,10))
    assert_equal new(2006,1,5,10,10,10),   7.months.from(new(2005,6,5,10,10,10))
    assert_equal new(2006,6,5,10,10,10),   12.months.from(new(2005,6,5,10,10,10))
    assert_equal new(2007,6,5,10,10,10),   24.months.from(new(2005,6,5,10,10,10))
    assert_equal new(2005,4,30,10,10,10),  1.months.from(new(2005,3,31,10,10,10))
    assert_equal new(2005,2,28,10,10,10),  1.months.from(new(2005,1,29,10,10,10))
    assert_equal new(2005,2,28,10,10,10),  1.months.from(new(2005,1,30,10,10,10))
    assert_equal new(2005,2,28,10,10,10),  1.months.from(new(2005,1,31,10,10,10))
  end

  def test_years_until
    assert_equal new(2004,6,5,10,10,10),  1.years.until(new(2005,6,5,10,10,10))
    assert_equal new(1998,6,5,10,10,10),  7.years.until(new(2005,6,5,10,10,10))
    assert_equal new(2003,2,28,10,10,10), 1.years.until(new(2004,2,29,10,10,10)) # 1 year ago from leap day
  end

  def test_years_from
    assert_equal new(2006,6,5,10,10,10),  1.years.from(new(2005,6,5,10,10,10))
    assert_equal new(2012,6,5,10,10,10),  7.years.from(new(2005,6,5,10,10,10))
    assert_equal new(2005,2,28,10,10,10), 1.years.from(new(2004,2,29,10,10,10)) # 1 year from leap day
    assert_equal new(2182,6,5,10,10,10),  177.years.from(new(2005,6,5,10,10,10))
  end
end
