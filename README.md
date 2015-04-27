# AS::Duration

This gem is an extraction of `ActiveSupport::Duration` from Rails, along with the
related core extensions.

Ruby 2.0 or greater is required.

## Why not simply use ActiveSupport?

If you're in a Rails project, then you should use `ActiveSupport::Duration`.
Otherwise there are several reason why you might prefer `as-duration`:

* You simply don't want to have ActiveSupport as a dependency
* You want to control what you require. You may think that requiring
  `active_support/core_ext/integer/time` will only require what you want, but
  in fact it will require a total of **5000 LOC** (a lot of those are additional
  core extensions which you may not have wanted). `as-duration` has only
  under **200 LOC**, and only gives you what you've asked for.

## Is it well tested?

It sure is! I copied all the related tests from Rails, and modified them
so that they work standalone. So, `as-duration` passes all of Rails' tests.

## Installation

```ruby
gem 'as-duration'
```

## Features

*NOTE: In most cases `as-duration` should work exactly like
`ActiveSupport::Duration`. However, there are a few modifications made, mostly
removing some of the magic, see [Modifications](#modifications-to-activesupportduration).*

### Numeric methods

The following methods are added on `Numeric` (`Float` and `Integer`):

```rb
# plural versions
2.seconds
3.minutes
4.hours
5.days
6.weeks
7.fortnights
8.months
9.years

# singular versions
1.second
1.minute
1.hour
1.day
1.week
1.fortnight
1.month
1.year
```

The only exception is `#months` and `#years` which are only added to `Integer`
(to maintain precision in calculations).

### Duration/Time arithmetics

You can add and subtract durations from `Time` or `Date` objects.

```rb
Time.now + 2.hours
Date.today + 1.year
```

When you add seconds/minutes/hours to a Date, the Date is automatically
converted to a `Time` object.

```rb
(Date.today + 1.minute).class #=> Time
```

As syntax sugar, you can also call time methods on the duration object:

```rb
# forward in time
1.year.from_now
2.months.since(Date.new(2015,4,27))
2.months.after(Date.new(2015,4,27))
2.months.from(Date.new(2015,4,27))

# back in time
2.hours.ago
20.minutes.until(Time.now)
20.minutes.before(Time.now)
20.minutes.to(Time.now)
```

### Duration/Duration arithmetics

You can add and subtract durations:

```rb
1.week + 1.day
2.minutes - 1.second
```

Unlike `ActiveSupport::Duration`, you can't add durations to integers and vice
versa. You either have to convert the integer to a duration, or
the duration to an integer with `AS::Duration#to_i`. This is to help you
not to mix different time units.

```rb
# Bad
10 + 1.minute  # TypeError
1.minute + 10  # TypeError

# Good
10.seconds + 1.minute  # AS::Duration
1.minute.to_i + 10     # Integer
```

## Modifications to `ActiveSupport::Duration`

The behaviour of `ActiveSupport::Duration` has been slightly modified, mostly
to remove some magic:

* Added `#from`, `#after`, `#before` and `#to` to `AS::Duration`
* `#from_now` and `#ago` cannot take any arguments, they always use the current
  time (passing an argument doesn't read well, better to use `#from` and
  `#until`)
* Removed support for `DateTime`
  - `DateTime` was first introduced in Ruby so that you can represent time
    that the `Time` class at the moment wasn't able to. However, the `Time`
    class improved over time and removed those limitations, so there is no more
    need to use `DateTime`
* Year lasts 365 days instead of 365.25
* `AS::Duration` doesn't act like an Integer
  - to compare it with an integer you have to either convert the integer to
    a duration or convert the duration to an integer (with `#to_i`)
  - you can only add and subtract two duration objects
* Removed hash equality

## License

[MIT](LICENSE.txt)
