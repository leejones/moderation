module Moderation
  module Adapters
    module Redis
      class Query

        def initialize(collection, name, limit)
          @dataset = collection.dataset
          @name    = name
          @limit   = limit
        end

        def all(options = {})
          fetch_limit = options.fetch(:limit, @limit).to_i - 1
          @dataset.lrange(@name, 0, fetch_limit) || []
        end

      end
    end
  end
end
