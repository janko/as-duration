require_relative "test_helper"
require_relative "date_and_time_behaviour"

class DateTest < Minitest::Test
  include DateAndTimeBehaviour

  def setup
    @date = Date.today
  end

  def new(*args)
    Date.new(*args.first(3))
  end

  def test_advance
    assert_equal new(2006,2,28),  new(2005,2,28) + 1.year
    assert_equal new(2005,6,28),  new(2005,2,28) + 4.months
    assert_equal new(2005,3,21),  new(2005,2,28) + 3.weeks
    assert_equal new(2005,3,5),   new(2005,2,28) + 5.days
    assert_equal new(2012,9,28),  new(2005,2,28) + (7.years + 7.months)
    assert_equal new(2013,10,3),  new(2005,2,28) + (7.years + 19.months + 5.days)
    assert_equal new(2013,10,17), new(2005,2,28) + (7.years + 19.months + 2.weeks + 5.days)
  end

  def test_advance_does_first_years_and_then_days
    assert_equal new(2012, 2, 29), new(2011, 2, 28) + (1.year + 1.day)
  end

  def test_advance_does_first_months_and_then_days
    assert_equal new(2010, 3, 29), new(2010, 2, 28) + (1.month + 1.day)
  end

  def test_leap_year
    assert_equal new(2005,2,28), new(2004,2,29) + 1.year
  end

  def test_calendar_reform
    assert_equal new(1582,10,15), new(1582,10,4) + 1.day
    assert_equal new(1582,10,4),  new(1582,10,15) - 1.day
    5.upto(14) do |day|
      assert_equal new(1582,10,4), new(1582,9,day) + 1.month
      assert_equal new(1582,10,4), new(1582,11,day) - 1.month
      assert_equal new(1582,10,4), new(1581,10,day) + 1.year
      assert_equal new(1582,10,4), new(1583,10,day) - 1.year
    end
  end

  def test_precision
    assert_equal @date + 1, @date + 1.day
    assert_equal @date >> 1, @date + 1.month
  end

  def test_conversion_to_time
    assert_equal 1.second.from(@date.to_time), @date + 1.second
    assert_equal 60.seconds.from(@date.to_time), @date + 1.minute
    assert_equal 60.minutes.from(@date.to_time), @date + 1.hour
  end
end
