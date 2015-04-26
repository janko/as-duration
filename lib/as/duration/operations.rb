module AS
  class Duration
    module Operations
      module DateAndTime
        def +(other)
          if Duration === other
            other.since(self)
          else
            super
          end
        end

        def -(other)
          if Duration === other
            other.until(self)
          else
            super
          end
        end
      end
    end
  end
end
