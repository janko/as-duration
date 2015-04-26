require "as/duration/operations"

class Date
  prepend AS::Duration::Operations::DateAndTime
end
