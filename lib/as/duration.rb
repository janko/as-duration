require "as/duration/core_ext"
require "time"

module AS
  class Duration
    include Comparable

    attr_reader :parts

    def initialize(parts)
      parts = parts.dup

      # Remove partial weeks and days for accurate date behaviour
      if Float === parts[:weeks]
        parts[:weeks], partial_weeks = parts[:weeks].divmod(1)
        parts[:days] = parts.fetch(:days, 0) + 7 * partial_weeks
      end
      if Float === parts[:days]
        parts[:days], partial_days = parts[:days].divmod(1)
        parts[:hours] = parts.fetch(:hours, 0) + 24 * partial_days
      end

      @parts = parts.freeze
    end

    def to_i
      @parts.inject(0) do |sum, (type, value)|
        case type
        when :seconds    then sum + value
        when :minutes    then sum + value * 60
        when :hours      then sum + value * 60 * 60
        when :days       then sum + value * 60 * 60 * 24
        when :weeks      then sum + value * 60 * 60 * 24 * 7
        when :fortnights then sum + value * 60 * 60 * 24 * 14
        when :months     then sum + value * 60 * 60 * 24 * 30
        when :years      then sum + value * 60 * 60 * 24 * 365
        end
      end
    end

    def <=>(other)
      return nil if not Duration === other
      self.to_i <=> other.to_i
    end

    def +(other)
      raise TypeError, "can only add Duration objects" if not Duration === other
      added_parts = parts.merge(other.parts) { |key, old, new| old + new }
      Duration.new(added_parts)
    end

    def -(other)
      raise TypeError, "can only subtract Duration objects" if not Duration === other
      self + (-other)
    end

    def -@
      negated_parts = parts.inject({}) { |h, (k, v)| h.update(k => -v) }
      Duration.new(negated_parts)
    end

    def from(time)
      advance(time)
    end
    alias since from
    alias after from

    def from_now
      from(Time.now)
    end

    def until(time)
      (-self).advance(time)
    end
    alias to     until
    alias before until

    def ago
      self.until(Time.now)
    end

    protected

    def advance(time)
      case time
      when Time then advance_time(time)
      when Date then advance_date(time)
      else
        raise ArgumentError, "expected Time or Date, got #{time.inspect}"
      end
    end

    def advance_time(time)
      date = advance_date_part(time.to_date)

      time_advanced_by_date_args =
        if time.utc?
          Time.utc(date.year, date.month, date.day, time.hour, time.min, time.sec)
        elsif time.zone
          Time.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
        else
          Time.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.utc_offset)
        end

      time_advanced_by_date_args + seconds_to_advance
    end

    def advance_date(date)
      date = advance_date_part(date)

      if seconds_to_advance == 0
        date
      else
        date.to_time + seconds_to_advance
      end
    end

    def advance_date_part(date)
      date = date >> parts.fetch(:years, 0) * 12
      date = date >> parts.fetch(:months, 0)
      date = date +  parts.fetch(:weeks, 0) * 7
      date = date +  parts.fetch(:days, 0)
      date = date.gregorian if date.julian?
      date
    end

    def seconds_to_advance
      parts.fetch(:seconds, 0) +
      parts.fetch(:minutes, 0) * 60 +
      parts.fetch(:hours, 0) * 3600
    end
  end
end
