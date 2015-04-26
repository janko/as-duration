require_relative "test_helper"
require_relative "date_and_time_behaviour"

class TimeTest < Minitest::Test
  include DateAndTimeBehaviour

  def setup
    @time = Time.now
  end

  def new(*args)
    Time.local(*args)
  end

  def test_calendar_reform
    assert_equal new(1582,10,14,15,15,10), 1.days.until(new(1582,10,15,15,15,10))
    assert_equal new(1582,10,15,15,15,10), 1.days.from(new(1582,10,14,15,15,10))
    assert_equal new(1582,10,5,15,15,10),  1.days.from(new(1582,10,4,15,15,10))
    assert_equal new(1582,10,4,15,15,10),  1.days.until(new(1582,10,5,15,15,10))
  end

  def test_since_and_until_with_fractional_days
    # since
    assert_equal 36.hours.since(@time), 1.5.days.since(@time)
    assert_in_delta((24 * 1.7).hours.since(@time), 1.7.days.since(@time), 1)
    # until
    assert_equal 36.hours.until(@time), 1.5.days.until(@time)
    assert_in_delta((24 * 1.7).hours.until(@time), 1.7.days.until(@time), 1)
  end

  def test_since_and_until_with_fractional_weeks
    # since
    assert_equal((7 * 36).hours.since(@time), 1.5.weeks.since(@time))
    assert_in_delta((7 * 24 * 1.7).hours.since(@time), 1.7.weeks.since(@time), 1)
    # until
    assert_equal((7 * 36).hours.until(@time), 1.5.weeks.until(@time))
    assert_in_delta((7 * 24 * 1.7).hours.until(@time), 1.7.weeks.until(@time), 1)
  end

  def test_precision
    assert_equal 8.seconds.from(@time), @time + 8.seconds
    assert_equal 22.9.seconds.from(@time), @time + 22.9.seconds
    assert_equal 15.days.from(@time), @time + 15.days
    assert_equal 1.month.from(@time), @time + 1.month
  end

  def test_leap_year
    assert_equal Time.local(2005,2,28,15,15,10), Time.local(2004,2,29,15,15,10) + 1.year
    assert_equal Time.utc(2005,2,28,15,15,10), Time.utc(2004,2,29,15,15,10) + 1.year
    assert_equal Time.new(2005,2,28,15,15,10,'-08:00'), Time.new(2004,2,29,15,15,10,'-08:00') + 1.year
  end

  def test_adding_hours_across_dst_boundary
    with_env_tz 'CET' do
      assert_equal Time.local(2009,3,29,0,0,0) + 24.hours, Time.local(2009,3,30,1,0,0)
    end
  end

  def test_adding_day_across_dst_boundary
    with_env_tz 'CET' do
      assert_equal Time.local(2009,3,29,0,0,0) + 1.day, Time.local(2009,3,30,0,0,0)
    end
  end

  def test_daylight_savings_time_crossings_backward_start
    with_env_tz 'US/Eastern' do
      # dt: US: 2005 April 3rd 4:18am
      assert_equal Time.local(2005,4,2,3,18,0), Time.local(2005,4,3,4,18,0) - 24.hours
      assert_equal Time.local(2005,4,2,3,18,0), Time.local(2005,4,3,4,18,0) - 86400.seconds

      assert_equal Time.local(2005,4,1,4,18,0), Time.local(2005,4,2,4,18,0) - 24.hours
      assert_equal Time.local(2005,4,1,4,18,0), Time.local(2005,4,2,4,18,0) - 86400.seconds
    end
    with_env_tz 'NZ' do
      # dt: New Zealand: 2006 October 1st 4:18am
      assert_equal Time.local(2006,9,30,3,18,0), Time.local(2006,10,1,4,18,0) - 24.hours
      assert_equal Time.local(2006,9,30,3,18,0), Time.local(2006,10,1,4,18,0) - 86400.seconds

      assert_equal Time.local(2006,9,29,4,18,0), Time.local(2006,9,30,4,18,0) - 24.hours
      assert_equal Time.local(2006,9,29,4,18,0), Time.local(2006,9,30,4,18,0) - 86400.seconds
    end
  end

  def test_daylight_savings_time_crossings_backward_end
    with_env_tz 'US/Eastern' do
      # st: US: 2005 October 30th 4:03am
      assert_equal Time.local(2005,10,29,5,3), Time.local(2005,10,30,4,3,0) - 24.hours
      assert_equal Time.local(2005,10,29,5,3), Time.local(2005,10,30,4,3,0) - 86400.seconds

      assert_equal Time.local(2005,10,28,4,3), Time.local(2005,10,29,4,3,0) - 24.hours
      assert_equal Time.local(2005,10,28,4,3), Time.local(2005,10,29,4,3,0) - 86400.seconds
    end
    with_env_tz 'NZ' do
      # st: New Zealand: 2006 March 19th 4:03am
      assert_equal Time.local(2006,3,18,5,3), Time.local(2006,3,19,4,3,0) - 24.hours
      assert_equal Time.local(2006,3,18,5,3), Time.local(2006,3,19,4,3,0) - 86400.seconds

      assert_equal Time.local(2006,3,17,4,3), Time.local(2006,3,18,4,3,0) - 24.hours
      assert_equal Time.local(2006,3,17,4,3), Time.local(2006,3,18,4,3,0) - 86400.seconds
    end
  end

  def test_daylight_savings_time_crossings_backward_start_1day
    with_env_tz 'US/Eastern' do
      # dt: US: 2005 April 3rd 4:18am
      assert_equal Time.local(2005,4,2,4,18,0), Time.local(2005,4,3,4,18,0) - 1.day
      assert_equal Time.local(2005,4,1,4,18,0), Time.local(2005,4,2,4,18,0) - 1.day
    end
    with_env_tz 'NZ' do
      # dt: New Zealand: 2006 October 1st 4:18am
      assert_equal Time.local(2006,9,30,4,18,0), Time.local(2006,10,1,4,18,0) - 1.day
      assert_equal Time.local(2006,9,29,4,18,0), Time.local(2006,9,30,4,18,0) - 1.day
    end
  end

  def test_daylight_savings_time_crossings_backward_end_1day
    with_env_tz 'US/Eastern' do
      # st: US: 2005 October 30th 4:03am
      assert_equal Time.local(2005,10,29,4,3), Time.local(2005,10,30,4,3,0) - 1.day
      assert_equal Time.local(2005,10,28,4,3), Time.local(2005,10,29,4,3,0) - 1.day
    end
    with_env_tz 'NZ' do
      # st: New Zealand: 2006 March 19th 4:03am
      assert_equal Time.local(2006,3,18,4,3), Time.local(2006,3,19,4,3,0) - 1.day
      assert_equal Time.local(2006,3,17,4,3), Time.local(2006,3,18,4,3,0) - 1.day
    end
  end

  def test_daylight_savings_time_crossings_forward_start
    with_env_tz 'US/Eastern' do
      # st: US: 2005 April 2nd 7:27pm
      assert_equal Time.local(2005,4,3,20,27,0), Time.local(2005,4,2,19,27,0) + 24.hours
      assert_equal Time.local(2005,4,3,20,27,0), Time.local(2005,4,2,19,27,0) + 86400.seconds

      assert_equal Time.local(2005,4,4,19,27,0), Time.local(2005,4,3,19,27,0) + 24.hours
      assert_equal Time.local(2005,4,4,19,27,0), Time.local(2005,4,3,19,27,0) + 86400.seconds
    end
    with_env_tz 'NZ' do
      # st: New Zealand: 2006 September 30th 7:27pm
      assert_equal Time.local(2006,10,1,20,27,0), Time.local(2006,9,30,19,27,0) + 24.hours
      assert_equal Time.local(2006,10,1,20,27,0), Time.local(2006,9,30,19,27,0) + 86400.seconds

      assert_equal Time.local(2006,10,2,19,27,0), Time.local(2006,10,1,19,27,0) + 24.hours
      assert_equal Time.local(2006,10,2,19,27,0), Time.local(2006,10,1,19,27,0) + 86400.seconds
    end
  end

  def test_daylight_savings_time_crossings_forward_start_1day
    with_env_tz 'US/Eastern' do
      # st: US: 2005 April 2nd 7:27pm
      assert_equal Time.local(2005,4,3,19,27,0), Time.local(2005,4,2,19,27,0) + 1.day
      assert_equal Time.local(2005,4,4,19,27,0), Time.local(2005,4,3,19,27,0) + 1.day
    end
    with_env_tz 'NZ' do
      # st: New Zealand: 2006 September 30th 7:27pm
      assert_equal Time.local(2006,10,1,19,27,0), Time.local(2006,9,30,19,27,0) + 1.day
      assert_equal Time.local(2006,10,2,19,27,0), Time.local(2006,10,1,19,27,0) + 1.day
    end
  end

  def test_daylight_savings_time_crossings_forward_end
    with_env_tz 'US/Eastern' do
      # dt: US: 2005 October 30th 12:45am
      assert_equal Time.local(2005,10,30,23,45,0), Time.local(2005,10,30,0,45,0) + 24.hours
      assert_equal Time.local(2005,10,30,23,45,0), Time.local(2005,10,30,0,45,0) + 86400.seconds

      assert_equal Time.local(2005,11, 1,0,45,0), Time.local(2005,10,31,0,45,0) + 24.hours
      assert_equal Time.local(2005,11, 1,0,45,0), Time.local(2005,10,31,0,45,0) + 86400.seconds
    end
    with_env_tz 'NZ' do
      # dt: New Zealand: 2006 March 19th 1:45am
      assert_equal Time.local(2006,3,20,0,45,0), Time.local(2006,3,19,1,45,0) + 24.hours
      assert_equal Time.local(2006,3,20,0,45,0), Time.local(2006,3,19,1,45,0) + 86400.seconds

      assert_equal Time.local(2006,3,21,1,45,0), Time.local(2006,3,20,1,45,0) + 24.hours
      assert_equal Time.local(2006,3,21,1,45,0), Time.local(2006,3,20,1,45,0) + 86400.seconds
    end
  end

  def test_daylight_savings_time_crossings_forward_end_1day
    with_env_tz 'US/Eastern' do
      # dt: US: 2005 October 30th 12:45am
      assert_equal Time.local(2005,10,31,0,45,0), Time.local(2005,10,30,0,45,0) + 1.day
      assert_equal Time.local(2005,11, 1,0,45,0), Time.local(2005,10,31,0,45,0) + 1.day
    end
    with_env_tz 'NZ' do
      # dt: New Zealand: 2006 March 19th 1:45am
      assert_equal Time.local(2006,3,20,1,45,0), Time.local(2006,3,19,1,45,0) + 1.day
      assert_equal Time.local(2006,3,21,1,45,0), Time.local(2006,3,20,1,45,0) + 1.day
    end
  end

  def test_advance
    assert_equal Time.local(2006,2,28,15,15,10), Time.local(2005,2,28,15,15,10) + 1.year
    assert_equal Time.local(2005,6,28,15,15,10), Time.local(2005,2,28,15,15,10) + 4.months
    assert_equal Time.local(2005,3,21,15,15,10), Time.local(2005,2,28,15,15,10) + 3.weeks
    assert_equal Time.local(2005,3,25,3,15,10), Time.local(2005,2,28,15,15,10) + 3.5.weeks
    assert_in_delta Time.local(2005,3,26,12,51,10), Time.local(2005,2,28,15,15,10) + 3.7.weeks, 1
    assert_equal Time.local(2005,3,5,15,15,10), Time.local(2005,2,28,15,15,10) + 5.days
    assert_equal Time.local(2005,3,6,3,15,10), Time.local(2005,2,28,15,15,10) + 5.5.days
    assert_in_delta Time.local(2005,3,6,8,3,10), Time.local(2005,2,28,15,15,10) + 5.7.days, 1
    assert_equal Time.local(2012,9,28,15,15,10), Time.local(2005,2,28,15,15,10) + (7.years + 7.months)
    assert_equal Time.local(2013,10,3,15,15,10), Time.local(2005,2,28,15,15,10) + (7.years + 19.months + 5.days)
    assert_equal Time.local(2013,10,17,15,15,10), Time.local(2005,2,28,15,15,10) + (7.years + 19.months + 2.weeks + 5.days)
    assert_equal Time.local(2001,12,27,15,15,10), Time.local(2005,2,28,15,15,10) + (-3.years - 2.months - 1.day)
    assert_equal Time.local(2005,2,28,20,15,10), Time.local(2005,2,28,15,15,10) + 5.hours
    assert_equal Time.local(2005,2,28,15,22,10), Time.local(2005,2,28,15,15,10) + 7.minutes
    assert_equal Time.local(2005,2,28,15,15,19), Time.local(2005,2,28,15,15,10) + 9.seconds
    assert_equal Time.local(2005,2,28,20,22,19), Time.local(2005,2,28,15,15,10) + (5.hours + 7.minutes + 9.seconds)
    assert_equal Time.local(2005,2,28,10,8,1), Time.local(2005,2,28,15,15,10) + (-5.hours - 7.minutes - 9.seconds)
    assert_equal Time.local(2013,10,17,20,22,19), Time.local(2005,2,28,15,15,10) + (7.years + 19.months + 2.weeks + 5.days + 5.hours + 7.minutes + 9.seconds)
  end

  def test_utc_advance
    assert_equal Time.utc(2006,2,22,15,15,10), Time.utc(2005,2,22,15,15,10) + 1.year
    assert_equal Time.utc(2005,6,22,15,15,10), Time.utc(2005,2,22,15,15,10) + 4.months
    assert_equal Time.utc(2005,3,21,15,15,10), Time.utc(2005,2,28,15,15,10) + 3.weeks
    assert_equal Time.utc(2005,3,25,3,15,10), Time.utc(2005,2,28,15,15,10) + 3.5.weeks
    assert_in_delta Time.utc(2005,3,26,12,51,10), Time.utc(2005,2,28,15,15,10) + 3.7.weeks, 1
    assert_equal Time.utc(2005,3,5,15,15,10), Time.utc(2005,2,28,15,15,10) + 5.days
    assert_equal Time.utc(2005,3,6,3,15,10), Time.utc(2005,2,28,15,15,10) + 5.5.days
    assert_in_delta Time.utc(2005,3,6,8,3,10), Time.utc(2005,2,28,15,15,10) + 5.7.days, 1
    assert_equal Time.utc(2012,9,22,15,15,10), Time.utc(2005,2,22,15,15,10) + (7.years + 7.months)
    assert_equal Time.utc(2013,10,3,15,15,10), Time.utc(2005,2,22,15,15,10) + (7.years + 19.months + 11.days)
    assert_equal Time.utc(2013,10,17,15,15,10), Time.utc(2005,2,28,15,15,10) + (7.years + 19.months + 2.weeks + 5.days)
    assert_equal Time.utc(2001,12,27,15,15,10), Time.utc(2005,2,28,15,15,10) + (-3.years - 2.months - 1.day)
    assert_equal Time.utc(2005,2,28,20,15,10), Time.utc(2005,2,28,15,15,10) + 5.hours
    assert_equal Time.utc(2005,2,28,15,22,10), Time.utc(2005,2,28,15,15,10) + 7.minutes
    assert_equal Time.utc(2005,2,28,15,15,19), Time.utc(2005,2,28,15,15,10) + 9.seconds
    assert_equal Time.utc(2005,2,28,20,22,19), Time.utc(2005,2,28,15,15,10) + (5.hours + 7.minutes + 9.seconds)
    assert_equal Time.utc(2005,2,28,10,8,1), Time.utc(2005,2,28,15,15,10) + (-5.hours - 7.minutes - 9.seconds)
    assert_equal Time.utc(2013,10,17,20,22,19), Time.utc(2005,2,28,15,15,10) + (7.years + 19.months + 2.weeks + 5.days + 5.hours + 7.minutes + 9.seconds)
  end

  def test_offset_advance
    assert_equal Time.new(2006,2,22,15,15,10,'-08:00'), Time.new(2005,2,22,15,15,10,'-08:00') + 1.year
    assert_equal Time.new(2005,6,22,15,15,10,'-08:00'), Time.new(2005,2,22,15,15,10,'-08:00') + 4.months
    assert_equal Time.new(2005,3,21,15,15,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 3.weeks
    assert_equal Time.new(2005,3,25,3,15,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 3.5.weeks
    assert_in_delta Time.new(2005,3,26,12,51,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 3.7.weeks, 1
    assert_equal Time.new(2005,3,5,15,15,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 5.days
    assert_equal Time.new(2005,3,6,3,15,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 5.5.days
    assert_in_delta Time.new(2005,3,6,8,3,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 5.7.days, 1
    assert_equal Time.new(2012,9,22,15,15,10,'-08:00'), Time.new(2005,2,22,15,15,10,'-08:00') + (7.years + 7.months)
    assert_equal Time.new(2013,10,3,15,15,10,'-08:00'), Time.new(2005,2,22,15,15,10,'-08:00') + (7.years + 19.months + 11.days)
    assert_equal Time.new(2013,10,17,15,15,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + (7.years + 19.months + 2.weeks + 5.days)
    assert_equal Time.new(2001,12,27,15,15,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + (-3.years - 2.months - 1.day)
    assert_equal Time.new(2005,2,28,20,15,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 5.hours
    assert_equal Time.new(2005,2,28,15,22,10,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 7.minutes
    assert_equal Time.new(2005,2,28,15,15,19,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + 9.seconds
    assert_equal Time.new(2005,2,28,20,22,19,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + (5.hours + 7.minutes + 9.seconds)
    assert_equal Time.new(2005,2,28,10,8,1,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + (-5.hours - 7.minutes - 9.seconds)
    assert_equal Time.new(2013,10,17,20,22,19,'-08:00'), Time.new(2005,2,28,15,15,10,'-08:00') + (7.years + 19.months + 2.weeks + 5.days + 5.hours + 7.minutes + 9.seconds)
  end
end
