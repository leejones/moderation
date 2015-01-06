module Moderation
  module Adapters
    module Memory
      class Command

        def initialize(collection, limit)
          @dataset = collection.dataset
          @limit = limit
        end

        def insert(item)
          @dataset.unshift(item)

          if @dataset.count > @limit
            @dataset.pop(@dataset.count - @limit)
          end
          @dataset
        end

      end
    end
  end
end
