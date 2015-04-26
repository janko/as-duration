require "as/duration/operations"

class Time
  prepend AS::Duration::Operations::DateAndTime
end
