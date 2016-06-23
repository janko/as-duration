require "as/duration/core_ext"
require "time"

module AS
  class Duration
    include Comparable

    attr_accessor :value, :parts

    def initialize(value, parts)
      @value, @parts = value, parts
    end

    def to_i
      @value
    end
	
    # reference: Rails-->activesupport/lib/active_support/duration.rb
    # Add this method FOR something like 5.minutes.to_f, which is used in ActiveSupport::Cache::Entry#initialize.
    def to_f
      @value.to_f
    end

    def <=>(other)
      return nil if not Duration === other
      self.value <=> other.value
    end

    def +(other)
      raise TypeError, "can only add Duration objects" if not Duration === other
      Duration.new(value + other.value, parts + other.parts)
    end

    def -(other)
      raise TypeError, "can only subtract Duration objects" if not Duration === other
      self + (-other)
    end

    def -@
      Duration.new(-value, parts.map { |type, number| [type, -number] })
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
      Calculator.new(parts).advance(time)
    end

    class Calculator
      def initialize(parts)
        options = parts.inject({}) do |options, (type, number)|
          options.update(type => number) { |key, old, new| old + new }
        end

        # Remove partial weeks and days for accurate date behaviour
        if Float === options[:weeks]
          options[:weeks], partial_weeks = options[:weeks].divmod(1)
          options[:days] = options.fetch(:days, 0) + 7 * partial_weeks
        end
        if Float === options[:days]
          options[:days], partial_days = options[:days].divmod(1)
          options[:hours] = options.fetch(:hours, 0) + 24 * partial_days
        end

        @options = options
      end

      def advance(time)
        case time
        when Time then advance_time(time)
        when Date then advance_date(time)
        else
          raise ArgumentError, "expected Time or Date, got #{time.inspect}"
        end
      end

      private

      attr_reader :options

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
        date = date >> options.fetch(:years, 0) * 12
        date = date >> options.fetch(:months, 0)
        date = date +  options.fetch(:weeks, 0) * 7
        date = date +  options.fetch(:days, 0)
        date = date.gregorian if date.julian?
        date
      end

      def seconds_to_advance
        options.fetch(:seconds, 0) +
        options.fetch(:minutes, 0) * 60 +
        options.fetch(:hours, 0) * 3600
      end
    end
  end
end
