module Moderation
  module Adapters
    module Memory
      class Collection

        attr_reader :dataset

        def initialize
          @dataset = []
        end

      end
    end
  end
end
