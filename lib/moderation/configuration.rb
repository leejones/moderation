module Moderation
  class Configuration

    attr_accessor :limit

    def initialize
      self.limit = 25
    end
  end
end
