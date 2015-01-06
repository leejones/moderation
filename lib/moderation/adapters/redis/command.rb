module Moderation
  module Adapters
    module Redis
      class Command
        include Moderation::Adapters::Redis::Transaction

        def initialize(collection, name, limit)
          @dataset = collection.dataset
          @name    = name
          @limit   = limit
        end

        def insert(item)
          transaction do
            @dataset.lpush(@name, item)
            @dataset.ltrim(@name, 0, (@limit - 1))
          end
        end

        def delete(item, attribute=nil)
          @dataset.lrem(@name, 0, MultiJson.dump(item))
        end

        def clean!
          @dataset.del(@name)
        end

      end
    end
  end
end
