module Moderation
  module Adapters
    module Memory
      class Query

        def initialize(collection, limit)
          @dataset = collection.dataset
          @limit = limit
        end

        def all(options = {})
          fetch_limit = options.fetch(:limit, @limit).to_i
          @dataset.first(fetch_limit)
        end

      end
    end
  end
end
