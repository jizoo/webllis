module Shoulda::Matchers::ActiveModel
  class EnsureLengthOfMatcher
    def is_within(range)
      is_at_least(range.min) && is_at_most(range.max)
    end
  end
end
