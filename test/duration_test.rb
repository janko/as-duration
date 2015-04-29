require_relative "test_helper"

class DurationTest < Minitest::Test
  def test_addition
    left  = AS::Duration.new(1, [[:weeks, 1]])
    right = AS::Duration.new(2, [[:seconds, 1]])

    assert_equal([[:weeks, 1], [:seconds, 1]], (left + right).parts)
    assert_equal(3, (left + right).value)
  end

  def test_subtraction
    left  = AS::Duration.new(3, [[:weeks, 1]])
    right = AS::Duration.new(2, [[:seconds, 1]])

    assert_equal([[:weeks, 1], [:seconds, -1]], (left - right).parts)
    assert_equal(1, (left - right).value)
  end

  def test_negation
    duration = AS::Duration.new(3, [[:weeks, 1], [:seconds, -1]])

    assert_equal([[:weeks, -1], [:seconds, 1]], (-duration).parts)
    assert_equal(-3, (-duration).value)
  end

  def test_converting_to_seconds
    assert_equal(60,        (1.minute).to_i)
    assert_equal(600,       (10.minutes).to_i)
    assert_equal(4500,      (1.hour + 15.minutes).to_i)
    assert_equal(189000,    (2.days + 4.hours + 30.minutes).to_i)
    assert_equal(161481600, (5.years + 1.month + 1.fortnight).to_i)
  end

  def test_fractional_weeks
    assert_equal((86400 * 7) * 1.5, 1.5.weeks.to_i)
    assert_equal((86400 * 7) * 1.7, 1.7.weeks.to_i)
  end

  def test_fractional_days
    assert_equal(86400 * 1.5, 1.5.days.to_i)
    assert_equal(86400 * 1.7, 1.7.days.to_i)
  end

  def test_equality
    assert 1.day == 24.hours

    refute 1.day == 1.day.to_i
    refute 1.day.to_i == 1.day
    refute 1.day == "foo"
  end

  def test_inequality
    assert_equal(-1, 0.seconds <=> 1.seconds)
    assert_equal(0,  1.seconds <=> 1.seconds)
    assert_equal(1,  2.seconds <=> 1.seconds)

    assert_equal(nil, 1.minute <=> 1)
    assert_equal(nil, 1 <=> 1.minute)
  end

  def test_travel_methods_interface
    assert_equal Time.new(2015,10,10,10,10,10), 1.year.since(Time.new(2014,10,10,10,10,10))
    assert_equal Time.new(2015,10,10,10,10,10), 1.year.after(Time.new(2014,10,10,10,10,10))
    assert_equal Time.new(2015,10,10,10,10,10), 1.year.from(Time.new(2014,10,10,10,10,10))

    assert_equal Time.new(2015,10,10,10,10,10), 1.year.until(Time.new(2016,10,10,10,10,10))
    assert_equal Time.new(2015,10,10,10,10,10), 1.year.before(Time.new(2016,10,10,10,10,10))
    assert_equal Time.new(2015,10,10,10,10,10), 1.year.to(Time.new(2016,10,10,10,10,10))

    assert 1.second.from_now > Time.now
    assert 1.second.ago      < Time.now
  end

  def test_type_checking
    error = assert_raises(ArgumentError) { 1.second.from("foo") }
    assert_match 'Time or Date', error.message

    assert_raises(TypeError) { 1.second + 1 }
    assert_raises(TypeError) { 1 + 1.second }
    assert_raises(TypeError) { 1.second - 1 }
    assert_raises(TypeError) { 1 - 1.second }
  end

  def test_no_mutation
    parts = [[:weeks, 1.5], [:days, 2.5]]
    AS::Duration.new(1, parts).ago
    assert_equal([[:weeks, 1.5], [:days, 2.5]], parts)
  end
end
